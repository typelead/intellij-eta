package com.typelead.intellij.test;

import com.intellij.testFramework.fixtures.CodeInsightTestFixture;
import com.intellij.testFramework.fixtures.LightPlatformCodeInsightFixtureTestCase;

public abstract class LightPlatformCodeInsightFixtureTestCaseWrapper
  extends LightPlatformCodeInsightFixtureTestCase {

  public CodeInsightTestFixture getMyFixture() {
    return myFixture;
  }
}
