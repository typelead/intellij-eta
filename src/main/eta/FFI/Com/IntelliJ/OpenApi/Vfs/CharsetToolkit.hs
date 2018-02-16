module FFI.Com.IntelliJ.OpenApi.Vfs.CharsetToolkit
  (getDefaultCharset) where

import P
import Interop.Java.NIO

-- Start com.intellij.openapi.vfs.CharsetToolkit

data CharsetToolkit = CharsetToolkit @com.intellij.openapi.vfs.CharsetToolkit
  deriving Class

foreign import java unsafe getDefaultCharset :: Java CharsetToolkit Charset

-- End com.intellij.openapi.vfs.CharsetToolkit
