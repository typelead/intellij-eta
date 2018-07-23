module IntelliJ.Plugin.Eta.Lang.Parser.EtaPsiParser where

import P

import IntelliJ.Plugin.Eta.Lang.Psi.EtaNodeTypes
import IntelliJ.Plugin.Util.ParserBuilder

import FFI.Com.IntelliJ.Lang.ASTNode
import FFI.Com.IntelliJ.Lang.PsiParser
import FFI.Com.IntelliJ.Psi.Tree.IElementType
import FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Lang.Psi.EtaTokenTypes

data EtaPsiParser = EtaPsiParser
  @com.typelead.intellij.plugin.eta.lang.parser.EtaPsiParser
  deriving Class

type instance Inherits EtaPsiParser = '[Object, PsiParser]

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
  parseUnknown

-- Catchall for code we weren't able to parse.
parseUnknown :: Psi s ()
parseUnknown = do
  eof <- isEOF
  when (not eof) $ markStart $ do
    consumeUntilEOF
    markDone wEtaUnknown

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
parseImports = whenTokenIs (== jITimport) $ markStart $ do
  loop
  markDone wEtaImports
  where
  loop = do
    parseImport
    whenTokenIs (== jITsemi) advanceLexer
    whenTokenIs (== jITimport) loop

parseImport :: Psi s ()
parseImport = markStart $ do
  advanceLexer
  whenTokenIs (== jITqualified) advanceLexer
  parseImportModule
  whenTokenIs (== jITas) $ do
    advanceLexer
    markStart $ do
      expectTokenAdvance jITconid
      markDone wEtaImportAlias
  whenTokenIs (== jIToparen) $ do
    advanceLexer
    -- Also handles the jITcparen
    parseImportNames wEtaImportExplicit
  whenTokenIs (== jIThiding) $ do
    advanceLexer
    expectTokenAdvance jIToparen
    -- Also handles the jITcparen
    parseImportNames wEtaImportHidden
  markDone wEtaImport

parseImportModule :: Psi s ()
parseImportModule = markStart $ do
  t <- getTokenType
  if t `elem` [jITconid, jITqconid] then do
    advanceLexer
    markDone wEtaImportModule
  else
    markError $ "Missing import module"

parseImportNames :: EtaNodeTypeWrapper -> Psi s ()
parseImportNames wnode = do
  parseImportName wnode
  loop
  where
  loop = do
    t <- getTokenType
    if t == jITcparen then do
      advanceLexer
      return ()
    else if t == jITcomma then do
      advanceLexer
      parseImportName wnode
      loop
    else
      builderError "Expected close paren or comma in explicit name import"

parseImportName :: EtaNodeTypeWrapper -> Psi s ()
parseImportName wnode = do
  hasParen <- (jIToparen ==) <$> getTokenType
  when hasParen advanceLexer
  t <- getTokenType
  if t `elem` [jITconid, jITvarid, jITconsym, jITvarsym] then do
    markStart $ advanceLexer >> markDone wnode
    parseImportConstructorsOrMethods wnode
  else
    builderError "Invalid explicit import; expected id, constructor, or symbol"
  when hasParen $ expectTokenAdvance jITcparen

parseImportConstructorsOrMethods :: EtaNodeTypeWrapper -> Psi s ()
parseImportConstructorsOrMethods wnode = whenTokenIs (== jIToparen) $ do
  advanceLexer
  t <- getTokenType
  if t == jITdotdot then
    markStart $ advanceLexer >> markDone wnode
  else
    loop
  expectTokenAdvance jITcparen
  where
  loop = do
    parseImportName wnode
    whenTokenIs (== jITcomma) $ do
      advanceLexer
      loop
