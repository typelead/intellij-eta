module FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Lang.Psi.EtaFile where

import P

import FFI.Com.IntelliJ.Psi.FileViewProvider
import FFI.Com.IntelliJ.Psi.PsiFile

data {-# CLASS "com.typelead.intellij.plugin.eta.lang.psi.EtaFile" #-}
  EtaFile = EtaFile (Object# EtaFile)
  deriving Class

type instance Inherits EtaFile = '[PsiFile]

foreign import java unsafe "@new" newEtaFile
  :: FileViewProvider -> Java a EtaFile
