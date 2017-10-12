module IntelliJ.TestFramework.VfsTestUtil where

import P

foreign import java unsafe
  "@static com.intellij.testFramework.VfsTestUtil.overwriteTestData"
  overwriteTestData :: JString -> JString -> Java a ()
