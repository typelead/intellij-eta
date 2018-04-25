module JUnit.Runner.Result where

import P
import JUnit.Runner.Notification.Failure

data Result = Result
  @org.junit.runner.Result
  deriving Class

foreign import java unsafe "wasSuccessful" wasSuccessful
  :: Result -> Bool

foreign import java unsafe "getFailures" getFailures
  :: Result -> JList Failure

foreign import java unsafe "getFailureCount" getFailureCount
  :: Result -> Int

foreign import java unsafe "getRunCount" getRunCount
  :: Result -> Int

