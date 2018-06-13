module FFI.Com.IntelliJ.OpenApi.Diagnostic.Logger where

import P.Base

data Logger = Logger
  @com.intellij.openapi.diagnostic.Logger
  deriving Class

foreign import java unsafe
  "com.intellij.openapi.diagnostic.Logger.getInstance"
  getLogger :: JString -> Java a Logger

foreign import java unsafe "debug" logDebug :: JString -> Java Logger ()
foreign import java unsafe "info"  logInfo  :: JString -> Java Logger ()
foreign import java unsafe "warn"  logWarn  :: JString -> Java Logger ()
foreign import java unsafe "error" logError :: JString -> Java Logger ()
