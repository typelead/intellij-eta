module FFI.Com.IntelliJ.UI.TextAccessor where

import Java

data TextAccessor = TextAccessor
  @com.intellij.ui.TextAccessor
  deriving Class

foreign import java unsafe "@interface" setText
  :: (a <: TextAccessor) => JString -> Java a ()

foreign import java unsafe "@interface" getText
  :: (a <: TextAccessor) => Java a JString
