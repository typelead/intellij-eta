module IntelliJ.Plugin.Eta.Lang.Lexer.EtaLexer
 ( EtaLexer(..)
 , newEtaLexer
 ) where

import P
import Data.IORef
import Foreign.StablePtr

import FFI.Com.IntelliJ.Lexer.Lexer (Lexer, getTokenText)
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
  -- For now, let's not use `initialState` so intellij has to start from the beginning.
  -- If intellij sees a state zero then it will assume it can always start the lexer over
  -- from that position.
  setMyState 1
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
  pState = L.mkPState defaultFlags stringBuf srcLoc
  stringBuf = charSeqToStringBuffer buf
  srcLoc = (mkRealSrcLoc (mkFastString fileName) line col)
  -- Dummy values for constructing the srcLoc
  fileName = "mem"
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
    case L.unP (L.lexer False return) pState of
      L.POk pState' ltok -> do
        io $ writeIORef pStateRef pState'
        case ltok of
          L _ L.ITeof -> do
            io $ putStrLn "LEXER RECEIVED EOF"
            debugLexer Nothing
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
                    ( lineColToOffset myBuffer (srcSpanStartLine s) (srcSpanStartCol s)
                    , lineColToOffset myBuffer (srcSpanEndLine s) (srcSpanEndCol s)
                    )
                  -- TODO: Handle this more gracefully, maybe return a BAD_CHARACTER
                  -- for the remaining input.
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
              setMyNextTokenStart (startOffset - 1)
              setMyNextTokenEnd (endOffset - 1)
              debugLexer (Just (startOffset, endOffset, token, srcSpan))
            else do
              debugLexer (Just (startOffset, endOffset, token, srcSpan))
              error $
                "Unexpected case, startOffset was " ++ show startOffset
                ++ " and myTokenStart was " ++ show myTokenStart

doDebugLexer = True

debugLexer :: Maybe (Int, Int, L.Token, SrcSpan) -> Java EtaLexer ()
debugLexer info = when doDebugLexer $ do
  myState <- getMyState
  text <- getTokenText
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
    , ("text", "'" ++ fromJString (jStringReplace text (toJString "\n") (toJString "\\n")) ++ "'")
    , ("nextType", if isJNull myNextTokenType then "null" else fromJString $ toString myNextTokenType)
    , ("nextStart", show myNextTokenStart)
    , ("nextEnd", show myNextTokenEnd)
    , ("info", maybe "n/a" show info)
    ]
