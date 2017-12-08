module IntelliJ.Plugin.Eta.Lang.Lexer.EtaLexer
 ( EtaLexer(..)
 , newEtaLexer
 ) where

import P
import Data.IORef
import Foreign.StablePtr

import FFI.Com.IntelliJ.Lexer.Lexer (Lexer)
import FFI.Com.IntelliJ.OpenApi.Util.Text.StringUtil (lineColToOffset)
import FFI.Com.IntelliJ.Psi.Tree (IElementType)
import qualified FFI.Com.IntelliJ.Psi.TokenType as T
import FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Lang.Psi.EtaTokenTypes (tokenToIElementType)

import qualified Language.Eta.Parser.Lexer as L
import Language.Eta.BasicTypes.SrcLoc
import Language.Eta.Utils.FastString (mkFastString)
import Language.Eta.Utils.StringBuffer

import IntelliJ.Plugin.Eta.Lang.Utils

data {-# CLASS "com.typelead.intellij.plugin.eta.lang.lexer.AbstractEtaLexer" #-}
  AbstractEtaLexer = AbstractEtaLexer (Object# AbstractEtaLexer)
  deriving Class

type instance Inherits AbstractEtaLexer = '[Object, Lexer]

data {-# CLASS "com.typelead.intellij.plugin.eta.lang.lexer.EtaLexer" #-}
  EtaLexer = EtaLexer (Object# EtaLexer)
  deriving Class

type instance Inherits EtaLexer = '[AbstractEtaLexer]

foreign import java unsafe "@new" newEtaLexer :: Java a EtaLexer

foreign import java unsafe "@field myPStatePtr" getMyPStatePtr :: Java EtaLexer (StablePtr (IORef L.PState))
foreign import java unsafe "@field myPStatePtr" setMyPStatePtr :: StablePtr (IORef L.PState) -> Java EtaLexer ()

foreign import java unsafe "@field myState" getMyState :: Java EtaLexer Int
foreign import java unsafe "@field myState" setMyState :: Int -> Java EtaLexer ()

foreign import java unsafe "@field myTokenStart" getMyTokenStart :: Java EtaLexer Int
foreign import java unsafe "@field myTokenStart" setMyTokenStart :: Int -> Java EtaLexer ()

foreign import java unsafe "@field myTokenEnd" getMyTokenEnd :: Java EtaLexer Int
foreign import java unsafe "@field myTokenEnd" setMyTokenEnd :: Int -> Java EtaLexer ()

foreign import java unsafe "@field myBuffer" getMyBuffer :: Java EtaLexer CharSequence
foreign import java unsafe "@field myBuffer" setMyBuffer :: CharSequence -> Java EtaLexer ()

foreign import java unsafe "@field myBufferEnd" getMyBufferEnd :: Java EtaLexer Int
foreign import java unsafe "@field myBufferEnd" setMyBufferEnd :: Int -> Java EtaLexer ()

foreign import java unsafe "@field myTokenType" getMyTokenType :: Java EtaLexer IElementType
foreign import java unsafe "@field myTokenType" setMyTokenType :: IElementType -> Java EtaLexer ()

foreign import java unsafe "@field myNextTokenType" getMyNextTokenType :: Java EtaLexer IElementType
foreign import java unsafe "@field myNextTokenType" setMyNextTokenType :: IElementType -> Java EtaLexer ()

foreign import java unsafe "@field myNextTokenStart" getMyNextTokenStart :: Java EtaLexer Int
foreign import java unsafe "@field myNextTokenStart" setMyNextTokenStart :: Int -> Java EtaLexer ()

foreign import java unsafe "@field myNextTokenEnd" getMyNextTokenEnd :: Java EtaLexer Int
foreign import java unsafe "@field myNextTokenEnd" setMyNextTokenEnd :: Int -> Java EtaLexer ()

foreign export java "start" start :: CharSequence -> Int -> Int -> Int -> Java EtaLexer ()
start buf startOffset endOffset initialState = do
  setMyPStatePtr =<< mkPtr
  setMyState 1 -- For now, let's not use `initialState` so intellij has to start from the beginning
  setMyTokenStart startOffset
  setMyTokenEnd startOffset
  setMyBuffer buf
  setMyBufferEnd endOffset
  setMyTokenType unsafeJNull
  setMyNextTokenType unsafeJNull
  setMyNextTokenStart (-1)
  setMyNextTokenEnd (-1)
  advance
  where
  -- TODO: Do we need to freeStablePtr when we're done and/or before setting this one?
  mkPtr = io $ newIORef pState >>= newStablePtr
  pState = L.mkPState flags stringBuf srcLoc
  flags = defaultFlags
  stringBuf = charSeqToStringBuffer buf
  srcLoc = (mkRealSrcLoc (mkFastString fileName) line col)
  -- Dummy values for constructing the srcLoc
  fileName = "memory"
  line = 0
  col = 0

-- TODO: Should find a faster way to convert CharSequence to StringBuffer
charSeqToStringBuffer :: CharSequence -> StringBuffer
charSeqToStringBuffer = stringToStringBuffer . fromJString . toStringJava

foreign export java "advance" advance :: Java EtaLexer ()
advance = do
  nextTokenTypeOrNull <- getMyNextTokenType
  if not (isJNull nextTokenTypeOrNull) then do
    setMyTokenType nextTokenTypeOrNull
    setMyTokenStart =<< getMyNextTokenStart
    setMyTokenEnd =<< getMyNextTokenEnd
    setMyNextTokenType unsafeJNull
    setMyNextTokenStart (-1)
    setMyNextTokenEnd (-1)
    debugLexer Nothing
  else do
    pStatePtr <- getMyPStatePtr
    pStateRef <- io $ deRefStablePtr pStatePtr
    pState <- io $ readIORef pStateRef
    case L.unP (L.lexer True return) pState of
      L.POk pState' ltok -> do
        io $ writeIORef pStateRef pState'
        case ltok of
          L _ L.ITeof ->
            setMyTokenType unsafeJNull
          L srcSpan token -> do
            -- If myTokenType is null, we're starting fresh.
            oldTokenType <- getMyTokenType
            if isJNull oldTokenType then
              setMyTokenStart 0
            else
              getMyTokenEnd >>= setMyTokenStart

            myBuffer <- getMyBuffer
            -- TODO: This isn't efficient, but the only way we can get the offsets, for now.
            let (startOffset, endOffset) = case srcSpan of
                  RealSrcSpan s ->
                    ( lineColToOffset myBuffer (srcSpanStartLine s - 1) (srcSpanStartCol s - 1)
                    , lineColToOffset myBuffer (srcSpanEndLine s - 1)   (srcSpanEndCol s - 1)
                    )
                  -- TODO: Handle this more gracefully
                  _ -> error $ "Unable to obtain location info: " ++ show srcSpan

            let iElementType = tokenToIElementType token

            myTokenStart <- getMyTokenStart
            if startOffset == myTokenStart then do
              setMyTokenType iElementType
              setMyTokenEnd endOffset
              debugLexer (Just (startOffset, endOffset, token, srcSpan))
            -- Found a gap, inject a whitespace token, prepare the next token.
            else if startOffset > myTokenStart then do
              setMyTokenType T.whiteSpace
              setMyTokenEnd (startOffset - 1)
              setMyNextTokenType iElementType
              setMyNextTokenStart startOffset
              setMyNextTokenEnd endOffset
              debugLexer (Just (startOffset, endOffset, token, srcSpan))
            else do
              io $ putStrLn "ERROR CASE"
              debugLexer (Just (startOffset, endOffset, token, srcSpan))
              error $
                "Unexpected case, startOffset was " ++ show startOffset
                ++ " and myTokenStart was " ++ show myTokenStart

debugLexer :: Maybe (Int, Int, L.Token, SrcSpan) -> Java EtaLexer ()
debugLexer info = do
  myState <- getMyState
  myTokenStart <- getMyTokenStart
  myTokenEnd <- getMyTokenEnd
  myTokenType <- getMyTokenType
  myNextTokenType <- getMyNextTokenType
  myNextTokenStart <- getMyNextTokenStart
  myNextTokenEnd <- getMyNextTokenEnd
  io $ putStrLn $ intercalate ", " $ map (\(k, v) -> k ++ ":" ++ v) $
    [ ("start", show myTokenStart)
    , ("end", show myTokenEnd)
    , ("type", if isJNull myTokenType then "null" else fromJString $ toString myTokenType)
    , ("nextType", if isJNull myNextTokenType then "null" else fromJString $ toString myNextTokenType)
    , ("nextStart", show myNextTokenStart)
    , ("nextEnd", show myNextTokenEnd)
    , ("info", maybe "n/a" show info)
    ]
