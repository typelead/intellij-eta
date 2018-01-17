package com.typelead.intellij.plugin.eta.lang.lexer;

import com.intellij.lexer.Lexer;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

@RunWith(Parameterized.class)
public class EtaParsingLexerTest extends AbstractEtaLexerTest {

  public EtaParsingLexerTest(String testName) {
    super(testName);
  }

  @Override
  String getExpectPath() {
    return "parsing";
  }

  @Override
  protected Lexer createLexer() {
    return new EtaParsingLexer();
  }

  @Override
  String[] getIgnoredTests() {
    return new String[] {
      "CPP00001",
      "Import00003",
      "Layout00012",
      "Layout00020",
      "MagicHash00001",
      "Type00002",
      "Unicode00001"
    };
  }
}
