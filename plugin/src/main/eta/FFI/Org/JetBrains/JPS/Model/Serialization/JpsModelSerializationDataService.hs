module FFI.Org.JetBrains.JPS.Model.Serialization.JpsModelSerializationDataService where

import P
import Interop.Java.IO
import FFI.Org.JetBrains.JPS.Model.JpsProject

-- Start org.jetbrains.jps.model.serialization.JpsModelSerializationDataService

data JpsModelSerializationDataService = JpsModelSerializationDataService
  @org.jetbrains.jps.model.serialization.JpsModelSerializationDataService
    deriving Class

foreign import java unsafe
  "@static org.jetbrains.jps.model.serialization.JpsModelSerializationDataService"
  getBaseDirectory :: JpsProject -> Java JpsModelSerializationDataService File


-- End org.jetbrains.jps.model.serialization.JpsModelSerializationDataService
