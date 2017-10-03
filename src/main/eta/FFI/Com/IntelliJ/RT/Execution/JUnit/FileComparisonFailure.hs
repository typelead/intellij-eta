module FFI.Com.IntelliJ.RT.Execution.JUnit.FileComparisonFailure where

import P
import Control.Exception
import Java.Exception

data {-# CLASS "com.intellij.rt.execution.junit.FileComparisonFailure" #-}
  FileComparisonFailure = FileComparisonFailure (Object# FileComparisonFailure)
  deriving Class

type instance Inherits FileComparisonFailure = '[Throwable]

