module FFI.Com.IntelliJ.OpenApi.Project.Project where

import P

data {-# CLASS "com.intellij.openapi.project.Project" #-}
  Project = Project (Object# Project)
  deriving Class
