module FFI.Org.JetBrains.JPS.ModuleChunk where

import P
import Java.Collections
import FFI.Org.JetBrains.JPS.Model.Module.JpsModule

-- Start org.jetbrains.jps.ModuleChunk

data ModuleChunk = ModuleChunk @org.jetbrains.jps.ModuleChunk
  deriving Class

foreign import java unsafe getModule :: Java ModuleChunk (Set JpsModule)

-- End org.jetbrains.jps.ModuleChunk
