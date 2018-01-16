module Tests.EtaLexerTest where

import P
import FFI.Com.IntelliJ.Lexer.Lexer (Lexer)
import IntelliJ.Plugin.Eta.Lang.Lexer.EtaLexer (newEtaParsingLexer)
import Tests.Base.LexerTestCaseWrapper (LexerTestCaseWrapper, doTest)
import Tests.Utils

data EtaLexerTest = EtaLexerTest
  @com.typelead.EtaLexerTest
  deriving Class

type instance Inherits EtaLexerTest = '[LexerTestCaseWrapper]

foreign export java "getDirPath" getDirPath :: Java EtaLexerTest JString
getDirPath = return "src/test/resources/fixtures/eta"

foreign export java "createLexer" createLexer :: Java EtaLexerTest Lexer
createLexer = superCast <$> newEtaParsingLexer

foreign export java testArrow00001 :: Java EtaLexerTest ()
testArrow00001 = doTest

foreign export java testAStack00001 :: Java EtaLexerTest ()
testAStack00001 = doTest

foreign export java testCase00001 :: Java EtaLexerTest ()
testCase00001 = doTest

foreign export java testComment00001 :: Java EtaLexerTest ()
testComment00001 = doTest

foreign export java testComment00002 :: Java EtaLexerTest ()
testComment00002 = doTest

foreign export java testComment00003 :: Java EtaLexerTest ()
testComment00003 = doTest

foreign export java testComment00004 :: Java EtaLexerTest ()
testComment00004 = doTest

foreign export java testComment00005 :: Java EtaLexerTest ()
testComment00005 = doTest

foreign export java testComment00006 :: Java EtaLexerTest ()
testComment00006 = doTest

foreign export java testComment00007 :: Java EtaLexerTest ()
testComment00007 = doTest

foreign export java testComment00008 :: Java EtaLexerTest ()
testComment00008 = doTest

-- TODO: Lexer doesn't support CPP yet
-- foreign export java testCPP00001 :: Java EtaLexerTest ()
-- testCPP00001 = doTest

foreign export java testEta00001 :: Java EtaLexerTest ()
testEta00001 = doTest

foreign export java testExport00001 :: Java EtaLexerTest ()
testExport00001 = doTest

foreign export java testFFI00001 :: Java EtaLexerTest ()
testFFI00001 = doTest

foreign export java testFFI00002 :: Java EtaLexerTest ()
testFFI00002 = doTest

foreign export java testForAll00001 :: Java EtaLexerTest ()
testForAll00001 = doTest

foreign export java testFun00001 :: Java EtaLexerTest ()
testFun00001 = doTest

foreign export java testFun00002 :: Java EtaLexerTest ()
testFun00002 = doTest

foreign export java testFun00003 :: Java EtaLexerTest ()
testFun00003 = doTest

foreign export java testFun00004 :: Java EtaLexerTest ()
testFun00004 = doTest

foreign export java testFun00005 :: Java EtaLexerTest ()
testFun00005 = doTest

foreign export java testFun00006 :: Java EtaLexerTest ()
testFun00006 = doTest

foreign export java testFun00007 :: Java EtaLexerTest ()
testFun00007 = doTest

foreign export java testFun00008 :: Java EtaLexerTest ()
testFun00008 = doTest

foreign export java testFun00009 :: Java EtaLexerTest ()
testFun00009 = doTest

foreign export java testFun00010 :: Java EtaLexerTest ()
testFun00010 = doTest

foreign export java testFun00011 :: Java EtaLexerTest ()
testFun00011 = doTest

foreign export java testFun00012 :: Java EtaLexerTest ()
testFun00012 = doTest

foreign export java testFun00013 :: Java EtaLexerTest ()
testFun00013 = doTest

foreign export java testHello00001 :: Java EtaLexerTest ()
testHello00001 = doTest

foreign export java testHello00002 :: Java EtaLexerTest ()
testHello00002 = doTest

foreign export java testHello00003 :: Java EtaLexerTest ()
testHello00003 = doTest

foreign export java testImport00001 :: Java EtaLexerTest ()
testImport00001 = doTest

foreign export java testImport00002 :: Java EtaLexerTest ()
testImport00002 = doTest

-- TODO: Lexer doesn't support CPP yet
-- foreign export java testImport00003 :: Java EtaLexerTest ()
-- testImport00003 = doTest

foreign export java testImport00004 :: Java EtaLexerTest ()
testImport00004 = doTest

foreign export java testImport00005 :: Java EtaLexerTest ()
testImport00005 = doTest

foreign export java testImport00006 :: Java EtaLexerTest ()
testImport00006 = doTest

foreign export java testIncomplete00001 :: Java EtaLexerTest ()
testIncomplete00001 = doTest

foreign export java testInfix00001 :: Java EtaLexerTest ()
testInfix00001 = doTest

foreign export java testInstanceSigs00001 :: Java EtaLexerTest ()
testInstanceSigs00001 = doTest

foreign export java testInternalLexer :: Java EtaLexerTest ()
testInternalLexer = doTest

foreign export java testKind00001 :: Java EtaLexerTest ()
testKind00001 = doTest

foreign export java testKind00002 :: Java EtaLexerTest ()
testKind00002 = doTest

foreign export java testKind00003 :: Java EtaLexerTest ()
testKind00003 = doTest

foreign export java testKind00004 :: Java EtaLexerTest ()
testKind00004 = doTest

foreign export java testLambda00001 :: Java EtaLexerTest ()
testLambda00001 = doTest

foreign export java testLayout00001 :: Java EtaLexerTest ()
testLayout00001 = doTest

foreign export java testLayout00002 :: Java EtaLexerTest ()
testLayout00002 = doTest

foreign export java testLayout00003 :: Java EtaLexerTest ()
testLayout00003 = doTest

foreign export java testLayout00004 :: Java EtaLexerTest ()
testLayout00004 = doTest

foreign export java testLayout00005 :: Java EtaLexerTest ()
testLayout00005 = doTest

foreign export java testLayout00006 :: Java EtaLexerTest ()
testLayout00006 = doTest

foreign export java testLayout00007 :: Java EtaLexerTest ()
testLayout00007 = doTest

foreign export java testLayout00008 :: Java EtaLexerTest ()
testLayout00008 = doTest

foreign export java testLayout00009 :: Java EtaLexerTest ()
testLayout00009 = doTest

foreign export java testLayout00010 :: Java EtaLexerTest ()
testLayout00010 = doTest

foreign export java testLayout00011 :: Java EtaLexerTest ()
testLayout00011 = doTest

-- TODO: Lexer doesn't support CPP yet
-- foreign export java testLayout00012 :: Java EtaLexerTest ()
-- testLayout00012 = doTest

foreign export java testLayout00013 :: Java EtaLexerTest ()
testLayout00013 = doTest

foreign export java testLayout00014 :: Java EtaLexerTest ()
testLayout00014 = doTest

foreign export java testLayout00015 :: Java EtaLexerTest ()
testLayout00015 = doTest

foreign export java testLayout00016 :: Java EtaLexerTest ()
testLayout00016 = doTest

foreign export java testLayout00017 :: Java EtaLexerTest ()
testLayout00017 = doTest

foreign export java testLayout00018 :: Java EtaLexerTest ()
testLayout00018 = doTest

foreign export java testLayout00019 :: Java EtaLexerTest ()
testLayout00019 = doTest

-- TODO: Lexer doesn't support CPP yet
-- foreign export java testLayout00020 :: Java EtaLexerTest ()
-- testLayout00020 = doTest

foreign export java testLayout00021 :: Java EtaLexerTest ()
testLayout00021 = doTest

foreign export java testLayout00022 :: Java EtaLexerTest ()
testLayout00022 = doTest

foreign export java testLayout00023 :: Java EtaLexerTest ()
testLayout00023 = doTest

foreign export java testLayout00024 :: Java EtaLexerTest ()
testLayout00024 = doTest

foreign export java testLayout00025 :: Java EtaLexerTest ()
testLayout00025 = doTest

foreign export java testLet00001 :: Java EtaLexerTest ()
testLet00001 = doTest

foreign export java testList00001 :: Java EtaLexerTest ()
testList00001 = doTest

foreign export java testList00002 :: Java EtaLexerTest ()
testList00002 = doTest

-- TODO: Lexer doesn't support CPP yet
-- foreign export java testMagicHash00001 :: Java EtaLexerTest ()
-- testMagicHash00001 = doTest

foreign export java testMinimal00001 :: Java EtaLexerTest ()
testMinimal00001 = doTest

foreign export java testModule00001 :: Java EtaLexerTest ()
testModule00001 = doTest

foreign export java testOperator00001 :: Java EtaLexerTest ()
testOperator00001 = doTest

foreign export java testOperator00002 :: Java EtaLexerTest ()
testOperator00002 = doTest

foreign export java testPragma00001 :: Java EtaLexerTest ()
testPragma00001 = doTest

foreign export java testPragma00002 :: Java EtaLexerTest ()
testPragma00002 = doTest

foreign export java testPragma00003 :: Java EtaLexerTest ()
testPragma00003 = doTest

foreign export java testPragma00004 :: Java EtaLexerTest ()
testPragma00004 = doTest

foreign export java testPragma00005 :: Java EtaLexerTest ()
testPragma00005 = doTest

foreign export java testProc00001 :: Java EtaLexerTest ()
testProc00001 = doTest

foreign export java testQuote00001 :: Java EtaLexerTest ()
testQuote00001 = doTest

foreign export java testRecord00001 :: Java EtaLexerTest ()
testRecord00001 = doTest

foreign export java testRecord00002 :: Java EtaLexerTest ()
testRecord00002 = doTest

foreign export java testStrict00001 :: Java EtaLexerTest ()
testStrict00001 = doTest

foreign export java testString00001 :: Java EtaLexerTest ()
testString00001 = doTest

foreign export java testString00002 :: Java EtaLexerTest ()
testString00002 = doTest

foreign export java testString00003 :: Java EtaLexerTest ()
testString00003 = doTest

foreign export java testString00004 :: Java EtaLexerTest ()
testString00004 = doTest

foreign export java testString00005 :: Java EtaLexerTest ()
testString00005 = doTest

foreign export java testString00006 :: Java EtaLexerTest ()
testString00006 = doTest

foreign export java testString00007 :: Java EtaLexerTest ()
testString00007 = doTest

foreign export java testTempHask00001 :: Java EtaLexerTest ()
testTempHask00001 = doTest

foreign export java testTempHask00002 :: Java EtaLexerTest ()
testTempHask00002 = doTest

foreign export java testTempHask00003 :: Java EtaLexerTest ()
testTempHask00003 = doTest

foreign export java testTempHask00004 :: Java EtaLexerTest ()
testTempHask00004 = doTest

foreign export java testTempHask00005 :: Java EtaLexerTest ()
testTempHask00005 = doTest

foreign export java testType00001 :: Java EtaLexerTest ()
testType00001 = doTest

-- TODO: Lexer doesn't support CPP yet
-- foreign export java testType00002 :: Java EtaLexerTest ()
-- testType00002 = doTest

foreign export java testType00003 :: Java EtaLexerTest ()
testType00003 = doTest

foreign export java testType00004 :: Java EtaLexerTest ()
testType00004 = doTest

foreign export java testType00005 :: Java EtaLexerTest ()
testType00005 = doTest

foreign export java testType00006 :: Java EtaLexerTest ()
testType00006 = doTest

-- TODO: Lexer doesn't support UnicodeSyntax yet.
-- foreign export java testUnicode00001 :: Java EtaLexerTest ()
-- testUnicode00001 = doTest

foreign export java testVar00001 :: Java EtaLexerTest ()
testVar00001 = doTest

foreign export java testViewPatterns00001 :: Java EtaLexerTest ()
testViewPatterns00001 = doTest
