-- The standard prelude for this project.
module P
  ( module P
  , module X
  ) where

import Prelude as X hiding (String, head, tail)
import Control.Exception as X
import Control.Monad as X
import Data.Maybe as X
import Data.Monoid as X
import Data.Typeable
import GHC.Base (unJava)
import Java as X hiding (getClass, maybeToJava, maybeFromJava, pureJava, (<.>))
import qualified Java
import qualified Java.Do
import qualified Java.Exception
import qualified Java.Utils
import qualified Unsafe.Coerce

unsafeCoerce :: a -> b
unsafeCoerce = Unsafe.Coerce.unsafeCoerce

type JavaEnum = Java.Utils.Enum

foreign import java unsafe
  "@static @field com.typelead.intellij.utils.JavaUtil.unsafeNull"
  unsafeNull :: (a <: Object) => a

foreign import java unsafe
  "@static @field com.typelead.intellij.utils.JavaUtil.emptyJString"
  emptyJString :: JString

getClass :: Class a => JClass a
getClass = Java.getClass undefined

data JClassAny = forall a. Class a => JClassAny (JClass a)

toJClassAny :: Class a => JClass a -> JClassAny
toJClassAny = JClassAny

data {-# CLASS "java.lang.Class[]" #-} JClassArray a
  = JClassArray (Object# (JClassArray a))
  deriving Class

instance Class a => JArray (JClass a) (JClassArray a)

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

getThis :: Class a => Java a a
getThis = withThis return

{-# INLINE dotImpl #-}
dotImpl :: Class c => (level (Java c a) -> Java c a) -> c -> level (Java c a) -> Java b a
dotImpl access cls method = Java $ \o -> case m (unobj cls) of (# _, a #) -> (# o, a #)
  where
  Java m = access method

class Accessible level c b where
  (<.>) :: Class c => c -> level (Java c a) -> Java b a

newtype Public a = Public { unPublic :: a }

instance (b <: c) => Accessible Public c b where
  (<.>) = dotImpl unPublic

newtype Protected a = Protected { unProtected :: a }

instance (b <: c) => Accessible Protected c b where
  (<.>) = dotImpl unProtected

newtype Private a = Private { unPrivate :: a }

instance Accessible Private c c where
  (<.>) = dotImpl unPrivate

instance Monoid JString where
  mempty = emptyJString
  mappend = jStringConcat

foreign import java unsafe trim :: JString -> JString

foreign import java unsafe "concat" jStringConcat :: JString -> JString -> JString

foreign import java unsafe "@static @field java.io.File.separator" jFileSeparator :: JString

-- Java Functions

type JFunction = Java.Do.Function

jFunction :: (t <: Object, r <: Object) => (t -> Java (JFunction t r) r) -> JFunction t r
jFunction = Java.Do.fun

data {-# CLASS "java.util.function.Supplier" #-}
  JSupplier a = JSupplier (Object# (JSupplier a))
  deriving Class

foreign import java unsafe "@wrapper get" jSupplier
  :: (a <: Object) => Java (JSupplier a) a -> JSupplier a

type instance Inherits (JSupplier a) = '[Object]

-- Java Exceptions

type JThrowable = Java.Exception.Throwable
type JException = Java.Exception.JException

data {-# CLASS "java.io.FileNotFoundException" #-}
  FileNotFoundException = FileNotFoundException (Object# FileNotFoundException)
  deriving (Class, Typeable, Show)

type instance Inherits FileNotFoundException = '[Object, JThrowable, JException]

-- foreign import java unsafe
--   "@static com.typelead.intellij.utils.JavaUtil.tryJava" tryJava'
--   :: (Class e, e <: JThrowable, a <: Object)
--   => JClass e -> JSupplier a -> Java.Do.Function e a -> Java b a
--
-- tryJava
--   :: (Class e, e <: JThrowable, a <: Object)
--   => Java (JSupplier a) a
--   -> (e -> Java (JFunction e a) a)
--   -> Java b a
-- tryJava f g = tryJava' getClass (jSupplier f) (jFunction g)

foreign import java unsafe
  "@static com.typelead.intellij.utils.JavaUtil.throwJava"
  throwJava' :: (e <: JThrowable) => e -> Java a ()

throwJava :: (e <: JThrowable) => e -> Java a b
throwJava e = throwJava' e >> return undefined

throwJavaM :: (e <: JThrowable) => Java a e -> Java a b
throwJavaM me = do
  e <- me
  throwJava e
