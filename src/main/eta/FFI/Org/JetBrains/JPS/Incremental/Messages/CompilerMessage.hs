module FFI.Org.JetBrains.JPS.Incremental.Messages.CompilerMessage where

import P
import FFI.Org.JetBrains.JPS.Incremental.Messages.BuildMessage

-- Start org.jetbrains.jps.incremental.messages.CompilerMessage

data CompilerMessage = CompilerMessage @org.jetbrains.jps.incremental.messages.CompilerMessage
  deriving Class

type instance Inherits CompilerMessage = '[BuildMessage]
