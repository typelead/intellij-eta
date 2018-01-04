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

foreign import java unsafe
  "@static @field com.typelead.intellij.plugin.eta.lang.EtaFileType.INSTANCE"
  etaFileType :: FileType

----------------------------
-- CodeInsightTestFixture --
----------------------------

data {-# CLASS "com.intellij.testFramework.fixtures.CodeInsightTestFixture" #-}
  CodeInsightTestFixture = CodeInsightTestFixture (Object# CodeInsightTestFixture)
  deriving Class

foreign import java unsafe configureByText
  :: FileType -> JString -> Java CodeInsightTestFixture PsiFile

foreign import java unsafe testHighlighting
  :: Java CodeInsightTestFixture Long

---------------------------------------------
-- LightPlatformCodeInsightFixtureTestCase --
---------------------------------------------

data {-# CLASS "com.intellij.testFramework.fixtures.LightPlatformCodeInsightFixtureTestCase" #-}
  LightPlatformCodeInsightFixtureTestCase = LightPlatformCodeInsightFixtureTestCase (Object# LightPlatformCodeInsightFixtureTestCase)
  deriving Class

type instance Inherits LightPlatformCodeInsightFixtureTestCase = '[UsefulTestCase]

foreign import java unsafe "@field myFixture" getMyFixture
  :: Java LightPlatformCodeInsightFixtureTestCase CodeInsightTestFixture

-- foreign import java unsafe configureByText
--   :: FileType -> JString -> Java CodeInsightTestCase PsiFile

------------------------------
-- EtaSyntaxHighlighterTest --
------------------------------

data {-# CLASS "com.typelead.EtaSyntaxHighlighterTest" #-}
  EtaSyntaxHighlighterTest = EtaSyntaxHighlighterTest (Object# EtaSyntaxHighlighterTest)
  deriving Class

type instance Inherits EtaSyntaxHighlighterTest = '[LightPlatformCodeInsightFixtureTestCase]

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
  configureLines xs = configureByText etaFileType (foldMap (<> "\n") xs)
