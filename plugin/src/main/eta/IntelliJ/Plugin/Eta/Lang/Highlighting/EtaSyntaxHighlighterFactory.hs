module IntelliJ.Plugin.Eta.Lang.Highlighting.EtaSyntaxHighlighterFactory where

import P

import FFI.Com.IntelliJ.OpenApi.Project.FileTypes.SyntaxHighlighter
import FFI.Com.IntelliJ.OpenApi.Project.FileTypes.SyntaxHighlighterFactory
import FFI.Com.IntelliJ.OpenApi.Project.Project
import FFI.Com.IntelliJ.OpenApi.Vfs.VirtualFile

import IntelliJ.Plugin.Eta.Lang.Highlighting.EtaSyntaxHighlighter

data {-# CLASS "com.typelead.intellij.plugin.eta.lang.highlighting.EtaSyntaxHighlighterFactory" #-}
  EtaSyntaxHighlighterFactory = EtaSyntaxHighlighterFactory (Object# EtaSyntaxHighlighterFactory)
  deriving Class

type instance Inherits EtaSyntaxHighlighterFactory = '[SyntaxHighlighterFactory]

foreign export java getSyntaxHighlighter
  :: Project
  -> VirtualFile
  -> Java EtaSyntaxHighlighterFactory SyntaxHighlighter
getSyntaxHighlighter _ _ = superCastJ newEtaSyntaxHighlighter

