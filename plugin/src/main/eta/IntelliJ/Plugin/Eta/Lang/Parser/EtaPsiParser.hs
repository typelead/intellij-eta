module IntelliJ.Plugin.Eta.Lang.Parser.EtaPsiParser where

import P

import IntelliJ.Plugin.Util.ParserBuilder

import FFI.Com.IntelliJ.Lang.ASTNode
import FFI.Com.IntelliJ.Lang.PsiParser
import FFI.Com.IntelliJ.Psi.Tree.IElementType

-- TODO: This doesn't work, attempts to use `extends` instead of `implements`
-- data EtaPsiParser = EtaPsiParser
--   @com.typelead.intellij.plugin.eta.lang.parser.EtaPsiParser
--   deriving Class
--
-- type instance Inherits EtaPsiParser = '[PsiParser]

data {-# CLASS "com.typelead.intellij.plugin.eta.lang.parser.EtaPsiParser implements com.intellij.lang.PsiParser" #-}
  EtaPsiParser = EtaPsiParser (Object# EtaPsiParser)
  deriving Class

-- Using this to get around the Inherits problem detailed above.
fromEtaPsiParser :: EtaPsiParser -> PsiParser
fromEtaPsiParser = unsafeRuntimeCast

foreign import java unsafe "@new" newEtaPsiParser :: Java a EtaPsiParser

foreign export java "parse"
  etaPsiParserParse :: IElementType -> PsiBuilder -> Java EtaPsiParser ASTNode
etaPsiParserParse   :: IElementType -> PsiBuilder -> Java EtaPsiParser ASTNode
etaPsiParserParse root psiBuilder = evalPsi psiBuilder $ do
  markStart $ top >> consumeUntilEOF >> markDone root
  getTreeBuilt

top :: Psi s ()
top = builderError "EtaPsiParser not implemented"
