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
  mkElement :: EtaNodeType -> ASTNode -> Java a EtaCompositeElement
  mkElement nodeType = case nodeType of
    -- Later we'll need to specialize these, leaving here for now.
    _  -> newEtaCompositeElement

data EtaCompositeElement = EtaCompositeElement
  @com.typelead.intellij.plugin.eta.lang.psi.EtaCompositeElement
  deriving Class

type instance Inherits EtaCompositeElement = '[ASTWrapperPsiElement]

foreign import java unsafe "@new" newEtaCompositeElement :: ASTNode -> Java a EtaCompositeElement
