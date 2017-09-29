module FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Lang.EtaLanguage where

import P
import FFI.Com.IntelliJ.Lang.Language

data {-# CLASS "com.typelead.intellij.plugin.eta.lang.EtaLanguage" #-}
  EtaLanguage = EtaLanguage (Object# EtaLanguage)
  deriving Class

type instance Inherits EtaLanguage = '[Object, Language]

foreign import java unsafe
  "@static com.typelead.intellij.plugin.eta.lang.EtaLanguage.INSTANCE"
  etaLanguage :: EtaLanguage
