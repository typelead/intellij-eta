package com.typelead.intellij.plugin.eta.lang.lexer;

import com.intellij.lexer.FlexAdapter;

public class EtaSyntaxHighlightingLexer extends FlexAdapter {
  public EtaSyntaxHighlightingLexer() {
    super(new _EtaSyntaxHighlightingLexer());
  }
}
