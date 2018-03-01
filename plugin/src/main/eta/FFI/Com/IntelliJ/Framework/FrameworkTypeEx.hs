module FFI.Com.IntelliJ.Framework.FrameworkTypeEx where

import P

import FFI.Com.IntelliJ.OpenApi.Extensions.ExtensionPointName

data FrameworkTypeEx = FrameworkTypeEx @com.intellij.framework.FrameworkTypeEx
  deriving Class

foreign import java unsafe
  "@static @field com.intellij.framework.FrameworkTypeEx.EP_NAME"
  frameworkTypeExEPName :: ExtensionPointName FrameworkTypeEx
