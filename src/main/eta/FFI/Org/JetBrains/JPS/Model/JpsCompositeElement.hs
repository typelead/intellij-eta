module FFI.Org.JetBrains.JPS.Model.JpsCompositeElement where

import P
import FFI.Org.JetBrains.JPS.Model.JpsElement
import FFI.Org.JetBrains.JPS.Model.JpsElementContainer

-- Start org.jetbrains.jps.model.JpsCompositeElement

data JpsCompositeElement = JpsCompositeElement @org.jetbrains.jps.model.JpsCompositeElement
  deriving Class

type instance Inherits JpsCompositeElement = '[JpsElement]

foreign import java unsafe getContainer :: Java JpsCompositeElement JpsElementContainer

-- End org.jetbrains.jps.model.JpsCompositeElement
