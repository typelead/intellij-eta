module Tests.Utils where

import P
import IntelliJ.TestFramework.LexerTestCase
import qualified JUnit.Framework.TestCase as T

assertEq :: (Show a, Eq a) => a -> a -> Java b ()
assertEq x y = when (x /= y) $ T.fail $ toJString $ show x ++ " /= " ++ show y

assertNothing :: Show a => Maybe a -> Java b ()
assertNothing mx = when (isJust mx) $ T.fail $ toJString $ "Expected Nothing, got " ++ show mx

assertJust :: Maybe a -> Java b ()
assertJust mx = when (isNothing mx) $ T.fail "Expected Just, got Nothing"
