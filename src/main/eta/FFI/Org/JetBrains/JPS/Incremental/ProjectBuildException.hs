module FFI.Org.JetBrains.JPS.Incremental.ProjectBuildException where

import P
import Data.Typeable

-- Start org.jetbrains.jps.incremental.ProjectBuildException

data ProjectBuildException = ProjectBuildException @org.jetbrains.jps.incremental.ProjectBuildException
  deriving (Class, Typeable)

type instance Inherits ProjectBuildException = '[JException]

foreign import java unsafe "@new" newProjectBuildException :: JString -> Java a ProjectBuildException

-- End org.jetbrains.jps.incremental.ProjectBuildException
