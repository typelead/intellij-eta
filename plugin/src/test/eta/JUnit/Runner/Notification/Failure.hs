module JUnit.Runner.Notification.Failure where

import P

data {-# CLASS "org.junit.runner.notification.Failure" #-} Failure
  = Failure (Object# Failure)
  deriving Class

