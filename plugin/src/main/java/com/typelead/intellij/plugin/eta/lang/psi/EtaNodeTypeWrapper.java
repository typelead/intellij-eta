package com.typelead.intellij.plugin.eta.lang.psi;

import com.intellij.psi.tree.IElementType;
import com.typelead.intellij.plugin.eta.lang.EtaLanguage;

public class EtaNodeTypeWrapper extends IElementType {

  public final int tagPtr;

  public EtaNodeTypeWrapper(String name, int tagPtr) {
    super(name, EtaLanguage.INSTANCE);
    this.tagPtr = tagPtr;
  }
}
