module FFI.Com.IntelliJ.Platform.ProjectTemplatesFactory where

import P.Base

data ProjectTemplatesFactory = ProjectTemplatesFactory
  @com.intellij.platform.ProjectTemplatesFactory
  deriving Class
