module IntelliJ.TestFramework.UsefulTestCase where

import P
import JUnit.Framework.TestCase

data {-# CLASS "com.intellij.testFramework.UsefulTestCase" #-}
  UsefulTestCase = UsefulTestCase (Object# UsefulTestCase)
  deriving Class

type instance Inherits UsefulTestCase = '[Object, TestCase]

foreign import java unsafe "getTestName" getTestName
  :: (a <: UsefulTestCase)
  => Bool -> Protected (Java a JString)

-- | Test name with lowercase first letter.
getTestNameLower :: (a <: UsefulTestCase) => Protected (Java a JString)
getTestNameLower = getTestName True

-- | Test name with uppercase first letter.
getTestNameUpper :: (a <: UsefulTestCase) => Protected (Java a JString)
getTestNameUpper = getTestName False
