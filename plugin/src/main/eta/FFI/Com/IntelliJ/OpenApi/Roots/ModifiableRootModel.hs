module FFI.Com.IntelliJ.OpenApi.Roots.ModifiableRootModel where

import Java
import P.Methods.GetProject
import FFI.Com.IntelliJ.OpenApi.Project.Project
import FFI.Com.IntelliJ.OpenApi.Roots.ContentEntry (ContentEntryArray)

data ModifiableRootModel = ModifiableRootModel
  @com.intellij.openapi.roots.ModifiableRootModel
  deriving Class

type instance Inherits ModifiableRootModel = '[Object]

foreign import java unsafe "@interface" getContentEntries
  :: Java ModifiableRootModel ContentEntryArray

foreign import java unsafe "@interface getProject" getProjectImpl
  :: Java ModifiableRootModel Project

instance GetProject ModifiableRootModel where
  getProject = getProjectImpl
