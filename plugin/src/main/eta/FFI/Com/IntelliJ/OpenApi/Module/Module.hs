module FFI.Com.IntelliJ.OpenApi.Module.Module where

import Java
import P.Methods.GetProject

data Module = Module
  @com.intellij.openapi.module.Module
  deriving Class


foreign import java unsafe "@interface getProject" getProjectImpl
  :: Java Module Project

instance GetProject Module where
  getProject = getProjectImpl
