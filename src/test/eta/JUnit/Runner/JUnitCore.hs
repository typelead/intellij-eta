module JUnit.Runner.JUnitCore where

import P
import JUnit.Runner.Result

foreign import java unsafe
  "@static org.junit.runner.JUnitCore.runClasses"
  runClasses :: JClassArray a -> Java b Result

