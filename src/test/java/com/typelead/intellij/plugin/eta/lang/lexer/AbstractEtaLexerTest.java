package com.typelead.intellij.plugin.eta.lang.lexer;

import com.intellij.lexer.Lexer;
import com.intellij.openapi.util.io.FileUtil;
import com.intellij.psi.tree.IElementType;
import com.intellij.rt.execution.junit.FileComparisonFailure;
import com.intellij.testFramework.LexerTestCase;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

public abstract class AbstractEtaLexerTest extends LexerTestCase {

  private static String dirPath() {
    return "src/test/resources/fixtures/eta";
  }

  private final String testName;

  AbstractEtaLexerTest(String testName) {
    this.testName = testName;
  }

  @Override
  protected final String getDirPath() {
    return dirPath();
  }

  @Parameters(name = "{0}")
  public static Collection<String> data() {
    try {
      return
        Files.list(Paths.get(dirPath(), "sources"))
          .map(x -> FileUtil.getNameWithoutExtension(x.toFile()))
          .collect(Collectors.toList());
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  abstract String getExpectPath();

  String[] getIgnoredTests() {
    return new String[0];
  }

  final boolean testShouldBeIgnored() {
    return new HashSet<>(Arrays.asList(getIgnoredTests())).contains(testName);
  }

  @Test
  public void test() {
    if (testShouldBeIgnored()) return;
    String fileName = testName + ".hs";
    String text = loadFile(FileUtil.join(getDirPath(), "sources", fileName));
    checkSegments(text);
    String tokenResult = printTokens(text, 0);
    String fullPath = FileUtil.join(getDirPath(), "lexer", getExpectPath());
    assertSameLinesWithFile(FileUtil.join(fullPath, testName + ".txt"), tokenResult, true);
  }

  private String loadFile(String path) {
    try {
      return FileUtil.loadFile(new File(path), true);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  private void checkSegments(String text) {
    int len = text.length();
    Lexer lexer = createLexer();
    lexer.start(text);
    IElementType firstTokenType = lexer.getTokenType();
    if (len == 0) assertNull(firstTokenType);
    else assertNotNull(firstTokenType);
    int lastEnd = 0;
    for (;;) {
      assertEquals(lastEnd, lexer.getTokenStart());
      lastEnd = lexer.getTokenEnd();
      lexer.advance();
      IElementType typ = lexer.getTokenType();
      if (typ == null) return;
    }
  }
}
