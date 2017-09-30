-- The standard prelude for this project.
module P
  ( module X
  , CharSequence
  , JavaEnum
  , maybeToJava
  , unsafeNull
  , unsafePerformJava
  ) where

import Prelude as X
import Data.Maybe as X
import Java as X hiding (maybeToJava, pureJava)
import qualified Java

import qualified Java.Utils

type JavaEnum = Java.Utils.Enum

-- TODO: Shouldn't this be brought in from GHC.Types by Prelude?
data {-# CLASS "java.lang.CharSequence" #-}
  CharSequence = CharSequence (Object# CharSequence)
  deriving Class

foreign import java unsafe
  "@static @field com.typelead.intellij.utils.JavaUtil.nullObject"
  unsafeNull :: (a <: Object) => a

maybeToJava :: (a <: Object) => Maybe a -> a
maybeToJava = fromMaybe unsafeNull

unsafePerformJava :: (forall c. Java c a) -> a
unsafePerformJava = Java.pureJava
