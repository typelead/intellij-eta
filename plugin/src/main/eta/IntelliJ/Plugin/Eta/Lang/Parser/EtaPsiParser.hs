module IntelliJ.Plugin.Eta.Lang.Parser.EtaPsiParser where

import P

import IntelliJ.Plugin.Eta.Lang.Psi.EtaNodeTypes
import IntelliJ.Plugin.Util.ParserBuilder

import FFI.Com.IntelliJ.Lang.ASTNode
import FFI.Com.IntelliJ.Lang.PsiParser
import FFI.Com.IntelliJ.Psi.Tree.IElementType
import FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Lang.Psi.EtaTokenTypes

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
top = do
  parseModule
  parseImports

parseModule :: Psi s ()
parseModule = whenTokenIs (== jITmodule) $ markStart $ do
  advanceLexer
  parseModuleName
  expectTokenAdvance jITwhere
  expectTokenAdvance jITvocurly
  markDone wEtaModule

parseModuleName :: Psi s ()
parseModuleName = markStart $ do
  t <- getTokenType
  if t `elem` [jITconid, jITqconid] then do
    advanceLexer
    markDone wEtaModuleName
  else
    markError $ "Missing module name"

parseImports :: Psi s ()
parseImports = whenTokenIs (== jITimport) $ do
  parseImport
  parseImports

parseImport :: Psi s ()
parseImport = markStart $ do
  advanceLexer
  parseImportModule
  markDone wEtaImport

parseImportModule :: Psi s ()
parseImportModule = markStart $ do
  t <- getTokenType
  if t `elem` [jITconid, jITqconid] then do
    advanceLexer
    markDone wEtaImportModule
  else
    markError $ "Missing import module"

parseImportExplicits :: Psi s ()
parseImportExplicits = whenTokenIs (== jIToparen) $ do
  advanceLexer
  parseImportExplicit
  loop
  where
  loop = do
    t <- getTokenType
    if t == jITcparen then do
      advanceLexer
      return ()
    else if t == jITcomma then do
      advanceLexer
      parseImportExplicit
      loop
    else
      builderError "Expected close paren or comma in explicit name import"

parseImportExplicit :: Psi s ()
parseImportExplicit = do
  hasParen <- (jIToparen ==) <$> getTokenType
  when hasParen advanceLexer
  t <- getTokenType
  if t `elem` [jITconid, jITvarid, jITconsym, jITvarsym] then markStart $ do
    advanceLexer
    markDone wEtaImportExplicit
  else
    builderError "Invalid explicit import; expected id, constructor, or symbol"
  when hasParen $ expectTokenAdvance jITcparen
