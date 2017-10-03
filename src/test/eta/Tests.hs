module Tests
 ( testClasses
 ) where

import P
import Tests.EtaLexerTest

testClasses :: [JClassAny]
testClasses =
  [ toJClassAny (getClass :: JClass EtaLexerTest)
  ]
