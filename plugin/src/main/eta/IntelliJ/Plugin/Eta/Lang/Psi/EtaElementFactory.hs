module IntelliJ.Plugin.Eta.Lang.Psi.EtaElementFactory where

import P

import FFI.Com.IntelliJ.ExtApi.Psi.ASTWrapperPsiElement
import FFI.Com.IntelliJ.Lang.ASTNode
import FFI.Com.IntelliJ.Psi.PsiElement

import IntelliJ.Plugin.Eta.Lang.Psi.EtaNodeTypes

createEtaElement :: ASTNode -> Java a PsiElement
createEtaElement node = do
  el <- node <.> getElementType
  case safeDowncast el :: Maybe EtaNodeTypeWrapper of
    Nothing -> error $ "Unexpected IElementType: " <> show el
    Just w -> superCastJ $ mkElement (getEtaNodeType w) node
  where
  mkElement :: EtaNodeType -> ASTNode -> Java a EtaPsiCompositeElement
  mkElement nodeType = case nodeType of
    EtaModule -> etaPsiModule
    EtaModuleName -> etaPsiModuleName
    EtaImports -> etaPsiImports
    EtaImport -> etaPsiImport
    EtaImportModule -> etaPsiImportModule
    EtaImportAlias -> etaPsiImportAlias
    EtaImportExplicits -> etaPsiImportExplicits
    EtaImportExplicit -> etaPsiImportExplicit
    EtaImportHiddens -> etaPsiImportHiddens
    EtaImportHidden -> etaPsiImportHidden
    EtaUnknown -> etaPsiUnknown

---------
-- FFI --
---------

data EtaPsiCompositeElement = EtaPsiCompositeElement
  @com.typelead.intellij.plugin.eta.lang.psi.EtaPsiCompositeElement
  deriving Class

type instance Inherits EtaPsiCompositeElement = '[ASTWrapperPsiElement]

foreign import java unsafe "@static com.typelead.intellij.plugin.eta.lang.psi.EtaPsiCompositeElement.etaPsiModule" etaPsiModule :: ASTNode -> Java a EtaPsiCompositeElement
foreign import java unsafe "@static com.typelead.intellij.plugin.eta.lang.psi.EtaPsiCompositeElement.etaPsiModuleName" etaPsiModuleName :: ASTNode -> Java a EtaPsiCompositeElement
foreign import java unsafe "@static com.typelead.intellij.plugin.eta.lang.psi.EtaPsiCompositeElement.etaPsiImports" etaPsiImports :: ASTNode -> Java a EtaPsiCompositeElement
foreign import java unsafe "@static com.typelead.intellij.plugin.eta.lang.psi.EtaPsiCompositeElement.etaPsiImport" etaPsiImport :: ASTNode -> Java a EtaPsiCompositeElement
foreign import java unsafe "@static com.typelead.intellij.plugin.eta.lang.psi.EtaPsiCompositeElement.etaPsiImportModule" etaPsiImportModule :: ASTNode -> Java a EtaPsiCompositeElement
foreign import java unsafe "@static com.typelead.intellij.plugin.eta.lang.psi.EtaPsiCompositeElement.etaPsiImportAlias" etaPsiImportAlias :: ASTNode -> Java a EtaPsiCompositeElement
foreign import java unsafe "@static com.typelead.intellij.plugin.eta.lang.psi.EtaPsiCompositeElement.etaPsiImportExplicits" etaPsiImportExplicits :: ASTNode -> Java a EtaPsiCompositeElement
foreign import java unsafe "@static com.typelead.intellij.plugin.eta.lang.psi.EtaPsiCompositeElement.etaPsiImportExplicit" etaPsiImportExplicit :: ASTNode -> Java a EtaPsiCompositeElement
foreign import java unsafe "@static com.typelead.intellij.plugin.eta.lang.psi.EtaPsiCompositeElement.etaPsiImportHiddens" etaPsiImportHiddens :: ASTNode -> Java a EtaPsiCompositeElement
foreign import java unsafe "@static com.typelead.intellij.plugin.eta.lang.psi.EtaPsiCompositeElement.etaPsiImportHidden" etaPsiImportHidden :: ASTNode -> Java a EtaPsiCompositeElement
foreign import java unsafe "@static com.typelead.intellij.plugin.eta.lang.psi.EtaPsiCompositeElement.etaPsiUnknown" etaPsiUnknown :: ASTNode -> Java a EtaPsiCompositeElement
