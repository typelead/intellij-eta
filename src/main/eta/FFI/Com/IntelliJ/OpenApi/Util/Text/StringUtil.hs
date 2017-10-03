module FFI.Com.IntelliJ.OpenApi.Util.Text.StringUtil where

foreign import java unsafe
  "@static com.intellij.openapi.util.text.StringUtil.convertLineSeparators"
  convertLineSeparators :: JString -> JString