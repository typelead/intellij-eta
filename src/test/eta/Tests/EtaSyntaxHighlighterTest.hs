module Tests.EtaSyntaxHighlighterTest where

import P

import FFI.Com.IntelliJ.Psi.PsiFile

import IntelliJ.TestFramework.UsefulTestCase

--------------
-- FileType --
--------------

data {-# CLASS "com.intellij.openapi.fileTypes.FileType" #-}
  FileType = FileType (Object# FileType)
  deriving Class

-----------------
-- EtaFileType --
-----------------

data {-# CLASS "com.typelead.intellij.plugin.eta.lang.EtaFileType" #-}
  EtaFileType = EtaFileType (Object# EtaFileType)
  deriving Class

type instance Inherits EtaFileType = '[FileType]

foreign import java unsafe
  "@static @field com.typelead.intellij.plugin.eta.lang.EtaFileType.INSTANCE"
  etaFileType :: EtaFileType

----------------------------
-- CodeInsightTestFixture --
----------------------------

data {-# CLASS "com.intellij.testFramework.fixtures.CodeInsightTestFixture" #-}
  CodeInsightTestFixture = CodeInsightTestFixture (Object# CodeInsightTestFixture)
  deriving Class

foreign import java unsafe "@interface" configureByText
  :: FileType -> JString -> Java CodeInsightTestFixture PsiFile

foreign import java unsafe testHighlighting
  :: Java CodeInsightTestFixture Long

---------------------------------------------
-- LightPlatformCodeInsightFixtureTestCase --
---------------------------------------------

data {-# CLASS "com.typelead.intellij.test.LightPlatformCodeInsightFixtureTestCaseWrapper" #-}
  LightPlatformCodeInsightFixtureTestCaseWrapper = LightPlatformCodeInsightFixtureTestCaseWrapper (Object# LightPlatformCodeInsightFixtureTestCaseWrapper)
  deriving Class

type instance Inherits LightPlatformCodeInsightFixtureTestCaseWrapper = '[UsefulTestCase]

foreign import java unsafe getMyFixture
  :: Java LightPlatformCodeInsightFixtureTestCaseWrapper CodeInsightTestFixture

------------------------------
-- EtaSyntaxHighlighterTest --
------------------------------

data {-# CLASS "com.typelead.EtaSyntaxHighlighterTest" #-}
  EtaSyntaxHighlighterTest = EtaSyntaxHighlighterTest (Object# EtaSyntaxHighlighterTest)
  deriving Class

type instance Inherits EtaSyntaxHighlighterTest = '[LightPlatformCodeInsightFixtureTestCaseWrapper]

foreign export java testSimple
           :: Java EtaSyntaxHighlighterTest ()
testSimple :: Java EtaSyntaxHighlighterTest ()
testSimple = do
  this <- getThis
  myFixture <- superCast this <.> getMyFixture
  myFixture <.> configureLines
    [ "module Main where"
    , "main = putStrLn \"Hello world" -- Unterminated string
    ]
  myFixture <.> testHighlighting
  return ()
  where
  configureLines xs = configureByText (superCast etaFileType) (foldMap (<> "\n") xs)
