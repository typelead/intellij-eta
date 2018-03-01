module FFI.Org.JetBrains.JPS.Incremental.Messages.BuildMessage where

import P

-- Start org.jetbrains.jps.incremental.messages.BuildMessage

data BuildMessage = BuildMessage @org.jetbrains.jps.incremental.messages.BuildMessage
  deriving Class

-- End org.jetbrains.jps.incremental.messages.BuildMessage

-- Start org.jetbrains.jps.incremental.messages.BuildMessage.Kind

data Kind = Kind @org.jetbrains.jps.incremental.messages.BuildMessage$Kind
  deriving Class

foreign import java unsafe
  "@static @field org.jetbrains.jps.incremental.messages.BuildMessage.Kind.ERROR" _ERROR ::
  Kind

foreign import java unsafe
  "@static @field org.jetbrains.jps.incremental.messages.BuildMessage.Kind.WARNING" _WARNING ::
  Kind

foreign import java unsafe
  "@static @field org.jetbrains.jps.incremental.messages.BuildMessage.Kind.INFO" _INFO ::
  Kind

foreign import java unsafe
  "@static @field org.jetbrains.jps.incremental.messages.BuildMessage.Kind.PROGRESS" _PROGRESS ::
  Kind

-- End org.jetbrains.jps.incremental.messages.BuildMessage.Kind
