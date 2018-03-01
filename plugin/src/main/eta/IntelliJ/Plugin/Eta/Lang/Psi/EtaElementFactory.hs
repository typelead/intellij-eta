module IntelliJ.Plugin.Eta.Lang.Psi.EtaElementFactory where

import P

import FFI.Com.IntelliJ.ExtApi.Psi.ASTWrapperPsiElement
import FFI.Com.IntelliJ.Lang.ASTNode
import FFI.Com.IntelliJ.Psi.PsiElement

createEtaElement :: ASTNode -> Java a PsiElement
createEtaElement node = superCastJ $ newASTWrapperPsiElement node
