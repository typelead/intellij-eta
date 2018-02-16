module FFI.Org.JetBrains.JPS.Incremental.CompileContext
  ( CompileContext
  , getProjectDescriptor
  ) where

import P
import FFI.Org.JetBrains.JPS.Incremental.MessageHandler
import FFI.Com.IntelliJ.IDE.Util.ImportProject.ProjectDescriptor
import FFI.Com.IntelliJ.OpenApi.Util.UserDataHandler

-- Start org.jetbrains.jps.incremental.CompileContext

data CompileContext = CompileContext @org.jetbrains.jps.incremental.CompileContext
  deriving Class

type instance Inherits CompileContext = '[UserDataHandler, MessageHandler]

foreign import java unsafe "@interface" getProjectDescriptor
  :: Java CompileContext ProjectDescriptor

-- End org.jetbrains.jps.incremental.CompileContext
