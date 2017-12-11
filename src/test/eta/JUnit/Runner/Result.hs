module JUnit.Runner.Result where

import P
import JUnit.Runner.Notification.Failure

data {-# CLASS "org.junit.runner.Result" #-} Result = Result (Object# Result)
  deriving Class

foreign import java unsafe "wasSuccessful" wasSuccessful
  :: Result -> Bool

foreign import java unsafe "getFailures" getFailures
  :: Result -> JList Failure

foreign import java unsafe "getFailureCount" getFailureCount
  :: Result -> Int

foreign import java unsafe "getRunCount" getRunCount
  :: Result -> Int

