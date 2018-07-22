-- Base of the prelude P module
-- This should be importable from anywhere (especially FFI modules),
-- so take care to not introduce any potential cyclical dependencies.
module P.Base
  ( module P.Base
  , module X
  ) where

import Prelude as X hiding (String, head, tail)
import Control.Exception as X
import Control.Monad as X
import Data.Foldable as X
import qualified Data.Int
import Data.List as X (intercalate, intersperse)
import Data.Maybe as X
import Data.Monoid as X
import Data.Typeable
import GHC.Base (isTrue#, isNullObject#)
import Java as X (
  JArray(..), type (<:), Object, JString, JStringArray, Class(..), JClass(..),
  Object#, Java(..), CharSequence(..), Inherits, Short(..), JavaConverter(..),
  withThis, arrayFromList, arrayToList, io, java, (<.>), fromJava, superCast, unsafeCast,
  unsafePerformJava,
  (>-)
  )
import Java.String as X (fromJString, toJString)
import qualified Java
import qualified Java.Do
import qualified Java.Exception
import Java.Utils as X (safeDowncast)
import qualified Java.Utils
import qualified Unsafe.Coerce

type Long = Data.Int.Int64

unsafeCoerce :: a -> b
unsafeCoerce = Unsafe.Coerce.unsafeCoerce

superCastJ :: (a <: b) => Java x a -> Java x b
superCastJ = (superCast <$>)

type JavaEnum = Java.Utils.Enum

type JList = Java.List

toStringJava :: (a <: Object) => a -> JString
toStringJava = Java.Utils.toString

foreign import java unsafe
  "@static @field com.typelead.intellij.utils.JavaUtil.unsafeNull"
  unsafeJNull :: (a <: Object) => a

foreign import java unsafe
  "@static @field com.typelead.intellij.utils.JavaUtil.emptyJString"
  emptyJString :: JString

isJNull :: (a <: Object) => a -> Bool
isJNull x = isTrue# (isNullObject# (unobj x))

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
maybeToJava = fromMaybe unsafeJNull

maybeFromJava :: (a <: Object) => a -> Maybe a
maybeFromJava x = if isJNull x then Nothing else Just x

data {-# CLASS "java.io.File" #-}
  JFile = JFile (Object# JFile)
  deriving Class

foreign import java unsafe "@new" newJFile :: JString -> Java a JFile

getThis :: Class a => Java a a
getThis = withThis return

instance Monoid JString where
  mempty = emptyJString
  mappend = jStringConcat

foreign import java unsafe "concat" jStringConcat :: JString -> JString -> JString

foreign import java unsafe "trim" trim :: JString -> JString

foreign import java unsafe "replace" jStringReplace
  :: (a <: CharSequence, b <: CharSequence)
  => JString -> a -> b -> JString

foreign import java unsafe "length" jStringLength :: JString -> Int

foreign import java unsafe "@interface length" charSeqLength :: CharSequence -> Int

foreign import java unsafe "@interface subSequence"
  charSeqSubSequence :: CharSequence -> Int -> Int -> CharSequence

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

foreign import java unsafe
  "@static com.typelead.intellij.utils.JavaUtil.unsafeRuntimeCast"
  unsafeRuntimeCast :: (a <: Object, b <: Object) => a -> b
