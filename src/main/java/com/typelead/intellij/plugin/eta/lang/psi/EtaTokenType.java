package com.typelead.intellij.plugin.eta.lang.psi;

import com.intellij.psi.tree.IElementType;
import com.typelead.intellij.plugin.eta.lang.EtaLanguage;
import org.jetbrains.annotations.NotNull;

public class EtaTokenType extends IElementType {
  public EtaTokenType(@NotNull String debugName) {
    super(debugName, EtaLanguage.INSTANCE);
  }
}
