module JUnit
 ( testMain
 ) where

import P
import JUnit.Runner.JUnitCore
import JUnit.Runner.Notification.Failure
import JUnit.Runner.Result

testMain :: [JClassAny] -> IO ()
testMain classes = do
  result <- runTests
  putStrLn $ "Ran " ++ show (getRunCount result) ++ " JUnit tests"
  when (not $ wasSuccessful result) $ do
    mapM_
      (putStrLn . fromJava . toStringJava)
      (fromJava $ getFailures result :: [Failure])
    putStrLn $ "Failed with " ++ show (getFailureCount result) ++ " failures"
    java $ exit 1
  where
  runTests :: IO Result
  runTests = java $ do
    classes' <- arrayFromList
      (map (\(JClassAny cls) -> unsafeCoerce cls) classes :: [JClass Object])
    runClasses classes'

foreign import java unsafe "@static java.lang.System.exit"
  exit :: Int -> Java a ()
