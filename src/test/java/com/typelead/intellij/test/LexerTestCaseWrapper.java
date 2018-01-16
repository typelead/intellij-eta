package com.typelead.intellij.test;

import com.intellij.lexer.Lexer;
import com.intellij.testFramework.LexerTestCase;
import org.jetbrains.annotations.NotNull;

/** Expose protected methods as public to call from Eta code. */
public abstract class LexerTestCaseWrapper extends LexerTestCase {

  @NotNull
  @Override
  public String getTestName(boolean lowercaseFirstLetter) {
    return super.getTestName(lowercaseFirstLetter);
  }

  @Override
  public String printTokens(String text, int start) {
    return super.printTokens(text, start);
  }

  @Override
  public abstract String getDirPath();

  @Override
  public abstract Lexer createLexer();
}
