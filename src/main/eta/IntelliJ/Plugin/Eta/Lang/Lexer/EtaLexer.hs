module IntelliJ.Plugin.Eta.Lang.Lexer.EtaLexer where

import P
import FFI.Com.IntelliJ.Lexer.Lexer (Lexer)
import FFI.Com.IntelliJ.Psi.Tree (IElementType)
import qualified Language.Eta.Parser.Lexer as L

data {-# CLASS "com.typelead.intellij.plugin.eta.lang.lexer.EtaLexer extends com.intellij.lexer.LexerBase" #-}
  EtaLexer = EtaLexer (Object# EtaLexer)
  deriving Class

type instance Inherits EtaLexer = '[Object, Lexer]

foreign import java unsafe "@new" newEtaLexer :: Java a EtaLexer

foreign export java "start" start :: CharSequence -> Int -> Int -> Int -> Java EtaLexer ()
start buffer startOffset endOffset initialState = undefined

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
