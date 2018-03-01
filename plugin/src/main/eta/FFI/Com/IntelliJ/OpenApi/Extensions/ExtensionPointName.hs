module FFI.Com.IntelliJ.OpenApi.Extensions.ExtensionPointName where

import P

data ExtensionPointName a = ExtensionPointName
  (@com.intellij.openapi.extensions.ExtensionPointName a)
  deriving Class

foreign import java unsafe findExtension
  :: (t <: Object, v <: t) => JClass v -> Java (ExtensionPointName t) v
