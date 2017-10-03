module FFI.Com.IntelliJ.OpenApi.Util.IO.FileUtil where

import P

foreign import java unsafe
  "@static com.intellij.openapi.util.io.FileUtil.loadFile"
  loadFile' :: JFile -> JString -> Java a JString

loadFile :: JString -> Java a JString
loadFile path = do
  file <- newJFile path
  loadFile' file "UTF-8"
