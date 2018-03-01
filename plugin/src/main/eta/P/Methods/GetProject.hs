module P.Methods.GetProject (
    GetProject(..)
  , Project
  ) where

import Java
import FFI.Com.IntelliJ.OpenApi.Project.Project

class GetProject a where
  getProject :: Java a Project
