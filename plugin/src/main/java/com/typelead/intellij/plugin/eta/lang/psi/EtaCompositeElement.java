package com.typelead.intellij.plugin.eta.lang.psi;

import com.intellij.extapi.psi.ASTWrapperPsiElement;
import com.intellij.lang.ASTNode;

public class EtaCompositeElement extends ASTWrapperPsiElement {
  public EtaCompositeElement(ASTNode node) {
    super(node);
  }

  @Override
  public String toString() {
    return getNode().getElementType().toString();
  }
}
