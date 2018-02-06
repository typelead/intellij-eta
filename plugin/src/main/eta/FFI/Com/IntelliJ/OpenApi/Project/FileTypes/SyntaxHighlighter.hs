module FFI.Com.IntelliJ.OpenApi.Project.FileTypes.SyntaxHighlighter where

import P

data {-# CLASS "com.intellij.openapi.fileTypes.SyntaxHighlighter" #-}
  SyntaxHighlighter = SyntaxHighlighter (Object# SyntaxHighlighter)
  deriving Class
