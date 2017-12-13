module FFI.Com.IntelliJ.OpenApi.Project.FileTypes.SyntaxHighlighterBase where

import P

import FFI.Com.IntelliJ.OpenApi.Editor.Colors.TextAttributesKey
import FFI.Com.IntelliJ.OpenApi.Project.FileTypes.SyntaxHighlighter

data {-# CLASS "com.intellij.openapi.fileTypes.SyntaxHighlighterBase" #-}
  SyntaxHighlighterBase = SyntaxHighlighterBase (Object# SyntaxHighlighterBase)
  deriving Class

type instance Inherits SyntaxHighlighterBase = '[SyntaxHighlighter]
