module FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Lang.Lexer.EtaSyntaxHighlightingLexer where

import P

import FFI.Com.IntelliJ.Lexer.Lexer

data EtaSyntaxHighlightingLexer = EtaSyntaxHighlightingLexer
  @com.typelead.intellij.plugin.eta.lang.lexer.EtaSyntaxHighlightingLexer
  deriving Class

type instance Inherits EtaSyntaxHighlightingLexer = '[Object, Lexer]

foreign import java unsafe "@new" newEtaSyntaxHighlightingLexer :: Java a EtaSyntaxHighlightingLexer
