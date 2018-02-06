module FFI.Com.IntelliJ.OpenApi.Editor.Colors.TextAttributesKey where

import P

data {-# CLASS "com.intellij.openapi.editor.colors.TextAttributesKey" #-}
  TextAttributesKey = TextAttributesKey (Object# TextAttributesKey)
  deriving Class

data {-# CLASS "com.intellij.openapi.editor.colors.TextAttributesKey[]" #-}
  TextAttributesKeyArray
  = TextAttributesKeyArray (Object# TextAttributesKeyArray)
  deriving Class

instance JArray TextAttributesKey TextAttributesKeyArray

foreign import java unsafe
  "@static com.intellij.openapi.editor.colors.TextAttributesKey.createTextAttributesKey"
  createTextAttributesKey :: JString -> TextAttributesKey -> TextAttributesKey

{-# NOINLINE emptyTextAttributesKeyArray #-}
emptyTextAttributesKeyArray :: TextAttributesKeyArray
emptyTextAttributesKeyArray = unsafePerformJava $ arrayFromList []
