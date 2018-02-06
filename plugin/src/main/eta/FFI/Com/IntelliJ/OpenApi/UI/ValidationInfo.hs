module FFI.Com.IntelliJ.OpenApi.UI.ValidationInfo where

import Java

data ValidationInfo = ValidationInfo
  @com.intellij.openapi.ui.ValidationInfo
  deriving Class
