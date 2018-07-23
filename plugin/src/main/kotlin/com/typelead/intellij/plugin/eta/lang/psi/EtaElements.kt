package com.typelead.intellij.plugin.eta.lang.psi

import com.intellij.extapi.psi.ASTWrapperPsiElement
import com.intellij.lang.ASTNode

sealed class EtaPsiCompositeElement(node: ASTNode) : ASTWrapperPsiElement(node) {
  override fun toString(): String = node.elementType.toString()

  // These smart constructors make it easier to construct on the Eta side.
  companion object {
    @JvmStatic fun etaPsiModule          (node: ASTNode): EtaPsiCompositeElement = EtaPsiModule          (node)
    @JvmStatic fun etaPsiModuleName      (node: ASTNode): EtaPsiCompositeElement = EtaPsiModuleName      (node)
    @JvmStatic fun etaPsiImports         (node: ASTNode): EtaPsiCompositeElement = EtaPsiImports         (node)
    @JvmStatic fun etaPsiImport          (node: ASTNode): EtaPsiCompositeElement = EtaPsiImport          (node)
    @JvmStatic fun etaPsiImportModule    (node: ASTNode): EtaPsiCompositeElement = EtaPsiImportModule    (node)
    @JvmStatic fun etaPsiImportAlias     (node: ASTNode): EtaPsiCompositeElement = EtaPsiImportAlias     (node)
    @JvmStatic fun etaPsiImportExplicits (node: ASTNode): EtaPsiCompositeElement = EtaPsiImportExplicits (node)
    @JvmStatic fun etaPsiImportExplicit  (node: ASTNode): EtaPsiCompositeElement = EtaPsiImportExplicit  (node)
    @JvmStatic fun etaPsiImportHiddens   (node: ASTNode): EtaPsiCompositeElement = EtaPsiImportHiddens   (node)
    @JvmStatic fun etaPsiImportHidden    (node: ASTNode): EtaPsiCompositeElement = EtaPsiImportHidden    (node)
    @JvmStatic fun etaPsiUnknown         (node: ASTNode): EtaPsiCompositeElement = EtaPsiUnknown         (node)
  }
}

class EtaPsiModule          (node: ASTNode) : EtaPsiCompositeElement(node)
class EtaPsiModuleName      (node: ASTNode) : EtaPsiCompositeElement(node)
class EtaPsiImports         (node: ASTNode) : EtaPsiCompositeElement(node)
class EtaPsiImport          (node: ASTNode) : EtaPsiCompositeElement(node)
class EtaPsiImportModule    (node: ASTNode) : EtaPsiCompositeElement(node)
class EtaPsiImportAlias     (node: ASTNode) : EtaPsiCompositeElement(node)
class EtaPsiImportExplicits (node: ASTNode) : EtaPsiCompositeElement(node)
class EtaPsiImportExplicit  (node: ASTNode) : EtaPsiCompositeElement(node)
class EtaPsiImportHiddens   (node: ASTNode) : EtaPsiCompositeElement(node)
class EtaPsiImportHidden    (node: ASTNode) : EtaPsiCompositeElement(node)
class EtaPsiUnknown         (node: ASTNode) : EtaPsiCompositeElement(node)
