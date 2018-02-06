module JUnit.Framework.TestCase where

import P

data {-# CLASS "junit.framework.TestCase" #-}
  TestCase = TestCase (Object# TestCase)
  deriving Class

foreign import java unsafe "@static junit.framework.TestCase.assertEquals" assertEquals
  :: (a <: Object, b <: Object)
  => a -> b -> Java c ()

foreign import java unsafe "@static junit.framework.TestCase.assertNull" assertNull
  :: (a <: Object)
  => a -> Java c ()

foreign import java unsafe "@static junit.framework.TestCase.assertNotNull" assertNotNull
  :: (a <: Object)
  => a -> Java c ()

foreign import java unsafe
  "@static junit.framework.TestCase.fail"
  fail :: JString -> Java a ()
