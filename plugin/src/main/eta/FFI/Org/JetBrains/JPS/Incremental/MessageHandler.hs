module FFI.Org.JetBrains.JPS.Incremental.MessageHandler where

import P
import FFI.Org.JetBrains.JPS.Incremental.Messages.BuildMessage

-- Start org.jetbrains.jps.incremental.MessageHandler

data MessageHandler = MessageHandler @org.jetbrains.jps.incremental.MessageHandler
  deriving Class

foreign import java unsafe "interface" processMessage :: BuildMessage -> Java MessageHandler ()

-- End org.jetbrains.jps.incremental.MessageHandler
