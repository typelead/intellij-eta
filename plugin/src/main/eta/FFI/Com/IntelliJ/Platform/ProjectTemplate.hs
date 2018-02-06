module FFI.Com.IntelliJ.Platform.ProjectTemplate where

import P.Base
import FFI.Com.IntelliJ.Ide.Util.ProjectWizard.AbstractModuleBuilder (AbstractModuleBuilder)
import FFI.Com.IntelliJ.OpenApi.UI.ValidationInfo (ValidationInfo)
import FFI.Javax.Swing.Icon (Icon)

data ProjectTemplate = ProjectTemplate
  @com.intellij.platform.ProjectTemplate
  deriving Class
  
data ProjectTemplateArray = ProjectTemplateArray
  @com.intellij.platform.ProjectTemplate[]
  deriving Class

instance JArray ProjectTemplate ProjectTemplateArray

foreign import java unsafe "@interface" createModuleBuilder
  :: Java ProjectTemplate AbstractModuleBuilder

foreign import java unsafe "@interface" getDescription
  :: Java ProjectTemplate JString

foreign import java unsafe "@interface" getIcon
  :: Java ProjectTemplate Icon

foreign import java unsafe "@interface" validateSettings
  :: Java ProjectTemplate ValidationInfo

foreign import java unsafe "@interface" getName
  :: Java ProjectTemplate JString
