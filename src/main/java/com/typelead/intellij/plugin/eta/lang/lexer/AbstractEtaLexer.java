package com.typelead.intellij.plugin.eta.lang.lexer;

import com.intellij.lexer.LexerBase;

/** Infrastructure required for implementing the EtaLexer from Eta. */
public abstract class AbstractEtaLexer extends LexerBase {

  // TODO: Ideally this should be PROTECTED; however, this makes it impossible to access
  // from Eta without security access exceptions.
  /** Backed by a StablePtr (IORef PState) */
  public int lexerPtr;
}
