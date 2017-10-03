-- The standard prelude for this project.
module P
  ( module P
  , module X
  ) where

import Prelude as X hiding (String, head, tail)
import Control.Monad as X
import Data.Maybe as X
import Data.Monoid as X
import GHC.Base (unJava)
import Java as X hiding (maybeToJava, maybeFromJava, pureJava, (<.>))
import qualified Java

import qualified Java.Utils

type JavaEnum = Java.Utils.Enum

-- TODO: Shouldn't this be brought in from GHC.Types by Prelude?
data {-# CLASS "java.lang.CharSequence" #-}
  CharSequence = CharSequence (Object# CharSequence)
  deriving Class

foreign import java unsafe
  "@static @field com.typelead.intellij.utils.JavaUtil.unsafeNull"
  unsafeNull :: (a <: Object) => a

maybeToJava :: (a <: Object) => Maybe a -> a
maybeToJava = fromMaybe unsafeNull

maybeFromJava :: (a <: Object) => a -> Maybe a
maybeFromJava x = if x `equals` (unsafeNull :: Object) then Nothing else Just x

unsafePerformJava :: (forall c. Java c a) -> a
unsafePerformJava = Java.pureJava

data {-# CLASS "java.io.File" #-}
  JFile = JFile (Object# JFile)
  deriving Class

foreign import java unsafe "@new" newJFile :: JString -> Java a JFile

{-# INLINE dotImpl #-}
dotImpl :: Class c => (level (Java c a) -> Java c a) -> c -> level (Java c a) -> Java b a
dotImpl access cls method = Java $ \o -> case m (unobj cls) of (# _, a #) -> (# o, a #)
  where
  Java m = access method

class Accessible level c b where
  (<.>) :: Class c => c -> level (Java c a) -> Java b a

newtype Public a = Public { unPublic :: a }

instance Accessible Public c b where
  (<.>) = dotImpl unPublic

newtype Protected a = Protected { unProtected :: a }

instance (b <: c) => Accessible Protected c b where
  (<.>) = dotImpl unProtected

newtype Private a = Private { unPrivate :: a }

instance Accessible Private c c where
  (<.>) = dotImpl unPrivate
