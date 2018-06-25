module FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Settings.EtaBuildSettings where

import Java
import FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Jps.Model.EtaBuildOptions (EtaBuildOptions)
import FFI.Com.IntelliJ.OpenApi.Project.Project

data EtaBuildSettings = EtaBuildSettings
  @com.typelead.intellij.plugin.eta.settings.EtaBuildSettings
  deriving Class

foreign import java unsafe "@static com.typelead.intellij.plugin.eta.settings.EtaBuildSettings.getInstance"
  getInstance :: Project -> Java a EtaBuildSettings

foreign import java unsafe "@new" newEtaBuildSettings
  :: Java a EtaBuildSettings

foreign import java unsafe "loadState" loadState
  :: EtaBuildOptions -> Java EtaBuildSettings ()

foreign import java unsafe setEtaPath
  :: JString -> Java EtaBuildSettings ()

foreign import java unsafe getEtaPath
  :: Java EtaBuildSettings JString

foreign import java unsafe setEtlasPath
  :: JString -> Java EtaBuildSettings ()

foreign import java unsafe getEtlasPath
  :: Java EtaBuildSettings JString

foreign import java unsafe "getState" getState
  :: Java EtaBuildSettings EtaBuildOptions

foreign import java unsafe noStateLoaded
  :: Java EtaBuildSettings ()
