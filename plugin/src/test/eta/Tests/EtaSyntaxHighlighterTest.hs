module Tests.EtaSyntaxHighlighterTest where

import P

import FFI.Com.IntelliJ.Psi.PsiFile

import IntelliJ.TestFramework.UsefulTestCase

--------------
-- FileType --
--------------

data FileType = FileType
  @com.intellij.openapi.fileTypes.FileType
  deriving Class

-----------------
-- EtaFileType --
-----------------

data EtaFileType = EtaFileType
  @com.typelead.intellij.plugin.eta.lang.EtaFileType
  deriving Class

type instance Inherits EtaFileType = '[FileType]

foreign import java unsafe
  "@static @field com.typelead.intellij.plugin.eta.lang.EtaFileType.INSTANCE"
  etaFileType :: EtaFileType

----------------------------
-- CodeInsightTestFixture --
----------------------------

data CodeInsightTestFixture = CodeInsightTestFixture
  @com.intellij.testFramework.fixtures.CodeInsightTestFixture
  deriving Class

foreign import java unsafe "@interface" configureByText
  :: FileType -> JString -> Java CodeInsightTestFixture PsiFile

foreign import java unsafe "@interface" testHighlighting
  :: JStringArray -> Java CodeInsightTestFixture Long

testHighlighting' :: Java CodeInsightTestFixture Long
testHighlighting' = arrayFromList [] >>= testHighlighting

---------------------------------------------
-- LightPlatformCodeInsightFixtureTestCase --
---------------------------------------------

data LightPlatformCodeInsightFixtureTestCaseWrapper = LightPlatformCodeInsightFixtureTestCaseWrapper
  @com.typelead.intellij.test.LightPlatformCodeInsightFixtureTestCaseWrapper
  deriving Class

type instance Inherits LightPlatformCodeInsightFixtureTestCaseWrapper = '[UsefulTestCase]

foreign import java unsafe getMyFixture
  :: Java LightPlatformCodeInsightFixtureTestCaseWrapper CodeInsightTestFixture

------------------------------
-- EtaSyntaxHighlighterTest --
------------------------------

data EtaSyntaxHighlighterTest = EtaSyntaxHighlighterTest
  @com.typelead.EtaSyntaxHighlighterTest
  deriving Class

type instance Inherits EtaSyntaxHighlighterTest = '[LightPlatformCodeInsightFixtureTestCaseWrapper]

foreign export java testSimple
           :: Java EtaSyntaxHighlighterTest ()
testSimple :: Java EtaSyntaxHighlighterTest ()
testSimple = do
  this <- getThis
  myFixture <- superCast this <.> getMyFixture

  -- Start with a well-formed string literal.
  _ <- myFixture <.> configureLines
    [ "module Main where"
    , "main = putStrLn \"Hello world\""
    ]
  _ <- myFixture <.> testHighlighting'

  -- Make it unterminated.
  _ <- myFixture <.> configureLines
    [ "module Main where"
    , "main = putStrLn \"Hello world"
    ]
  _ <- myFixture <.> testHighlighting'

  -- Make it well-formed again.
  _ <- myFixture <.> configureLines
    [ "module Main where"
    , "main = putStrLn \"Hello world\"" -- Unterminated string
    ]
  _ <- myFixture <.> testHighlighting'

  return ()
  where
  configureLines xs = configureByText (superCast etaFileType) (foldMap (<> "\n") xs)
