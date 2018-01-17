package com.typelead.intellij.plugin.eta.lang.lexer;

import com.intellij.lexer.LexerBase;
import com.intellij.psi.tree.IElementType;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

/** Infrastructure required for implementing the EtaParsingLexer from Eta. */
public abstract class AbstractEtaParsingLexer extends LexerBase {

  // TODO: Ideally these should be PROTECTED; however, this makes it impossible to access
  // from Eta without security access exceptions.

  /** Backed by a StablePtr (IORef PState) */
  public int myPStatePtr;

  public boolean done;
  public int myState;
  public int myTokenStart;
  public int myTokenEnd;
  public CharSequence myBuffer;
  public int myBufferEnd;
  public IElementType myTokenType;
  public IElementType myNextTokenType;
  public int myNextTokenStart;
  public int myNextTokenEnd;

  @Override
  public int getState() {
    return myState;
  }

  @Override
  public int getTokenStart() {
    return myTokenStart;
  }

  @Override
  public int getTokenEnd() {
    return myTokenEnd;
  }

  @NotNull
  @Override
  public CharSequence getBufferSequence() {
    return myBuffer;
  }

  @Override
  public int getBufferEnd() {
    return myBufferEnd;
  }

  @Nullable
  @Override
  public IElementType getTokenType() {
    return myTokenType;
  }
}
