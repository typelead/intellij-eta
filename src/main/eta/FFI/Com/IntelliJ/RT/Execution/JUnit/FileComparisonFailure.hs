module FFI.Com.IntelliJ.RT.Execution.JUnit.FileComparisonFailure where

import P

data {-# CLASS "com.intellij.rt.execution.junit.FileComparisonFailure" #-}
  FileComparisonFailure = FileComparisonFailure (Object# FileComparisonFailure)
  deriving Class

type instance Inherits FileComparisonFailure = '[Object, JThrowable]

foreign import java unsafe "@new" newFileComparisonFailure
  :: JString
  -> JString
  -> JString
  -> JString
  -> Java a FileComparisonFailure
