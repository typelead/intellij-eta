module IntelliJ.Plugin.Eta.Lang.Parser.EtaParserDefinition where

import P
import FFI.Com.IntelliJ.Lang.ASTNode
import FFI.Com.IntelliJ.Lang.ParserDefinition (SpaceRequirements)
import qualified FFI.Com.IntelliJ.Lang.ParserDefinition.SpaceRequirements as SpaceRequirements
import FFI.Com.IntelliJ.Psi
import FFI.Com.IntelliJ.Psi.Tree
import qualified FFI.Com.IntelliJ.Psi.TokenType as TokenType
import qualified FFI.Com.IntelliJ.Psi.Tree.TokenSet as TokenSet
import FFI.Com.IntelliJ.OpenApi.Project
import FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Lang.EtaLanguage
import IntelliJ.Plugin.Eta.Lang.Lexer.EtaLexer (EtaLexer, newEtaLexer)
import IntelliJ.Plugin.Eta.Lang.Parser.EtaParser (EtaParser, newEtaParser)

data {-# CLASS "com.typelead.intellij.plugin.eta.lang.parser.EtaParserDefinition extends com.intellij.lang.ParserDefinition" #-}
  EtaParserDefinition = EtaParserDefinition (Object# EtaParserDefinition)
  deriving Class

createLexer :: Java EtaParserDefinition EtaLexer
createLexer = newEtaLexer

foreign export java "createLexer" createLexer :: Java EtaParserDefinition EtaLexer

createParser :: Project -> Java EtaParserDefinition EtaParser
createParser project = newEtaParser

foreign export java "createParser" createParser :: Project -> Java EtaParserDefinition EtaParser

{-# NOINLINE fileNodeType #-}
fileNodeType :: IFileElementType
fileNodeType = pureJava $ newIFileElementType etaLanguage

getFileNodeType :: Java EtaParserDefinition IFileElementType
getFileNodeType = return fileNodeType

{-# NOINLINE whiteSpaces #-}
whiteSpaces :: TokenSet
whiteSpaces = TokenSet.create [TokenType.whiteSpace]

getWhitespaceTokens :: Java EtaParserDefinition TokenSet
getWhitespaceTokens = return whiteSpaces

foreign export java "getWhitespaceTokens" getWhitespaceTokens :: Java EtaParserDefinition TokenSet

getCommentTokens :: Java EtaParserDefinition TokenSet
getCommentTokens = return TokenSet.empty

foreign export java "getCommentTokens" getCommentTokens :: Java EtaParserDefinition TokenSet

getStringLiteralElements :: Java EtaParserDefinition TokenSet
getStringLiteralElements = return TokenSet.empty

foreign export java "getStringLiteralElements" getStringLiteralElements :: Java EtaParserDefinition TokenSet

createElement :: ASTNode -> Java EtaParserDefinition PsiElement
createElement = undefined

foreign export java "createElement" createElement
  :: ASTNode -> Java EtaParserDefinition PsiElement

createFile :: FileViewProvider -> Java EtaParserDefinition PsiFile
createFile fileViewProvider = undefined

foreign export java "createFile" createFile
  :: FileViewProvider -> Java EtaParserDefinition PsiFile

spaceExistanceTypeBetweenTokens :: ASTNode -> ASTNode -> Java EtaParserDefinition SpaceRequirements
spaceExistanceTypeBetweenTokens left right = return SpaceRequirements.may
