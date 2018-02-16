module FFI.Org.JetBrains.JPS.Model.JpsProject where

import P
import FFI.Org.JetBrains.JPS.Model.JpsCompositeElement
import FFI.Org.JetBrains.JPS.Model.JpsReferenceableElement

-- Start org.jetbrains.jps.model.JpsProject

data JpsProject = JpsProject @org.jetbrains.jps.model.JpsProject
  deriving Class

type instance Inherits JpsProject = '[JpsCompositeElement, JpsReferenceableElement JpsProject]

-- End org.jetbrains.jps.model.JpsProject
