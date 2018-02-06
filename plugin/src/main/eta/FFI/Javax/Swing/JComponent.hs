module FFI.Javax.Swing.JComponent
  ( JComponent
  , emptyJComponent
  ) where

import P.Base

data JComponent = JComponent
  @javax.swing.JComponent
  deriving Class

emptyJComponent :: Java a JComponent
emptyJComponent = superCastJ newEmptyJComponent

-- TODO: Workaround for lack of anonymous classes
data EmptyJComponent = EmptyJComponent
  @com.typelead.intellij.plugin.util.EmptyJComponent
  deriving Class

type instance Inherits EmptyJComponent = '[JComponent]

foreign import java unsafe "@new" newEmptyJComponent :: Java a EmptyJComponent

-- TODO: Dummy declaration to force Eta to export EmptyJComponent
foreign export java __dummy :: Java EmptyJComponent ()
__dummy :: Java EmptyJComponent ()
__dummy = return ()
