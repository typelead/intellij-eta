module FFI.Com.TypeLead.IntelliJ.Plugin.Eta.Jps.Model.EtaBuildOptions where

import Java

data EtaBuildOptions = EtaBuildOptions
  @com.typelead.intellij.eta.jps.model.EtaBuildOptions
  deriving Class

type instance Inherits EtaBuildOptions = '[Object]

foreign import java unsafe "@new" newEtaBuildOptions :: Java a EtaBuildOptions

-- There is a copy method, but this works just as well from Eta.
foreign import java unsafe "@new" copyEtaBuildOptions
  :: EtaBuildOptions -> Java a EtaBuildOptions
  
foreign import java unsafe "@field etaPath" getEtaPath :: Java EtaBuildOptions JString
foreign import java unsafe "@field etaPath" setEtaPath :: JString -> Java EtaBuildOptions ()

foreign import java unsafe "@field etlasPath" getEtlasPath :: Java a JString
foreign import java unsafe "@field etlasPath" setEtlasPath :: JString -> Java EtaBuildOptions ()
