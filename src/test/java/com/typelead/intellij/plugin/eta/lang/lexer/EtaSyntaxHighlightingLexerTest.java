package com.typelead.intellij.plugin.eta.lang.lexer;

import com.intellij.lexer.Lexer;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

@RunWith(Parameterized.class)
public class EtaSyntaxHighlightingLexerTest extends AbstractEtaLexerTest {

  public EtaSyntaxHighlightingLexerTest(String testName) {
    super(testName);
  }

  @Override
  String getExpectPath() {
    return "highlighting";
  }

  @Override
  protected Lexer createLexer() {
    return new EtaSyntaxHighlightingLexer();
  }
}
