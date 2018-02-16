module FFI.Com.IntelliJ.Execution.Process.BaseOSProcessHandler where

import P

-- Start com.intellij.execution.process.BaseOSProcessHandler

data BaseOSProcessHandler = BaseOSProcessHandler
  @com.intellij.execution.process.BaseOSProcessHandler
    deriving Class

-- TODO addProcessListener

foreign import java unsafe startNotify :: Java BaseOSProcessHandler ()

foreign import java unsafe waitFor :: Java BaseOSProcessHandler Bool

-- End com.intellij.execution.process.BaseOSProcessHandler
