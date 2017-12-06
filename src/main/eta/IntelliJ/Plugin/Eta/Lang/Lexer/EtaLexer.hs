module IntelliJ.Plugin.Eta.Lang.Lexer.EtaLexer where

import P
import FFI.Com.IntelliJ.Lexer.Lexer (Lexer)
import FFI.Com.IntelliJ.Psi.Tree (IElementType)
import Data.IORef
import Foreign.StablePtr
import qualified Language.Eta.Parser.Lexer as L

data {-# CLASS "com.typelead.intellij.plugin.eta.lang.lexer.AbstractEtaLexer" #-}
  AbstractEtaLexer = AbstractEtaLexer (Object# AbstractEtaLexer)
  deriving Class

type instance Inherits AbstractEtaLexer = '[Object, Lexer]

data {-# CLASS "com.typelead.intellij.plugin.eta.lang.lexer.EtaLexer" #-}
  EtaLexer = EtaLexer (Object# EtaLexer)
  deriving Class

type instance Inherits EtaLexer = '[AbstractEtaLexer]

foreign import java unsafe "@field lexerPtr" getLexerPtr :: Java EtaLexer (StablePtr (IORef L.PState))

foreign import java unsafe "@field lexerPtr" setLexerPtr :: StablePtr (IORef L.PState) -> Java EtaLexer ()

foreign import java unsafe "@new" newEtaLexer :: Java a EtaLexer

foreign export java "start" start :: CharSequence -> Int -> Int -> Int -> Java EtaLexer ()
start buffer startOffset endOffset initialState = do
  ptr <- mkPtr
  setLexerPtr ptr
  where
  mkPtr = io $ newIORef pState >>= newStablePtr
  pState = L.mkPState flags stringBuf srcLoc
  flags = undefined -- DynFlags
  stringBuf = undefined -- buffer.substring(startOffset, endOffset).to[StringBuffer]
  srcLoc = undefined -- RealSrcLoc

foreign export java "getState" getState :: Java EtaLexer Int
getState = return 0

-- Separate method which returns Maybe instead of @Nullable IElementType
-- When Eta FFI supports Maybe in the return type, we can get rid of the
-- getTokenTypeJava method in favor of this one.
getTokenType :: Java EtaLexer (Maybe IElementType)
getTokenType = undefined

foreign export java "getTokenType" getTokenTypeJava :: Java EtaLexer IElementType
getTokenTypeJava = maybeToJava <$> getTokenType

foreign export java "getTokenStart" getTokenStart :: Java EtaLexer Int
getTokenStart = undefined

foreign export java "getTokenEnd" getTokenEnd :: Java EtaLexer Int
getTokenEnd = undefined

foreign export java "advance" advance :: Java EtaLexer ()
advance = undefined

foreign export java "getBufferSequence" getBufferSequence :: Java EtaLexer CharSequence
getBufferSequence = undefined

foreign export java "getBufferEnd" getBufferEnd :: Java EtaLexer Int
getBufferEnd = undefined
