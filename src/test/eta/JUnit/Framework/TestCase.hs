module JUnit.Framework.TestCase where

data {-# CLASS "junit.framework.TestCase" #-}
  TestCase = TestCase (Object# TestCase)
  deriving Class
