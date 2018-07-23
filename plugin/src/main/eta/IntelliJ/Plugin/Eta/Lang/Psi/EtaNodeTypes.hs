module IntelliJ.Plugin.Eta.Lang.Psi.EtaNodeTypes where

import P

import Foreign.StablePtr

import FFI.Com.IntelliJ.Psi.Tree.IElementType

data EtaNodeType
  = EtaModule
  | EtaModuleName
  | EtaImports
  | EtaImport
  | EtaImportModule
  | EtaImportAlias
  | EtaImportExplicits
  | EtaImportExplicit
  | EtaImportHiddens
  | EtaImportHidden
  | EtaUnknown
  deriving (Show, Bounded, Enum, Eq)

{-# NOINLINE wEtaModule #-}
wEtaModule :: EtaNodeTypeWrapper
wEtaModule = unsafeMkNodeType EtaModule

{-# NOINLINE wEtaModuleName #-}
wEtaModuleName :: EtaNodeTypeWrapper
wEtaModuleName = unsafeMkNodeType EtaModuleName

{-# NOINLINE wEtaImports #-}
wEtaImports :: EtaNodeTypeWrapper
wEtaImports = unsafeMkNodeType EtaImports

{-# NOINLINE wEtaImport #-}
wEtaImport :: EtaNodeTypeWrapper
wEtaImport = unsafeMkNodeType EtaImport

{-# NOINLINE wEtaImportModule #-}
wEtaImportModule :: EtaNodeTypeWrapper
wEtaImportModule = unsafeMkNodeType EtaImportModule

{-# NOINLINE wEtaImportAlias #-}
wEtaImportAlias :: EtaNodeTypeWrapper
wEtaImportAlias = unsafeMkNodeType EtaImportAlias

{-# NOINLINE wEtaImportExplicits #-}
wEtaImportExplicits :: EtaNodeTypeWrapper
wEtaImportExplicits = unsafeMkNodeType EtaImportExplicits

{-# NOINLINE wEtaImportExplicit #-}
wEtaImportExplicit :: EtaNodeTypeWrapper
wEtaImportExplicit = unsafeMkNodeType EtaImportExplicit

{-# NOINLINE wEtaImportHiddens #-}
wEtaImportHiddens :: EtaNodeTypeWrapper
wEtaImportHiddens = unsafeMkNodeType EtaImportHiddens

{-# NOINLINE wEtaImportHidden #-}
wEtaImportHidden :: EtaNodeTypeWrapper
wEtaImportHidden = unsafeMkNodeType EtaImportHidden

{-# NOINLINE wEtaUnknown #-}
wEtaUnknown :: EtaNodeTypeWrapper
wEtaUnknown = unsafeMkNodeType EtaUnknown

{-# NOINLINE getEtaNodeType #-}
getEtaNodeType :: EtaNodeTypeWrapper -> EtaNodeType
getEtaNodeType w = unsafePerformJava $ w <.> get
  where
  get :: Java EtaNodeTypeWrapper EtaNodeType
  get = do
    ptr <- tagPtr
    io $ deRefStablePtr ptr

{-# NOINLINE unsafeMkNodeType #-}
unsafeMkNodeType :: EtaNodeType -> EtaNodeTypeWrapper
unsafeMkNodeType t = unsafePerformJava $ do
  ptr <- io $ newStablePtr t
  unsafeNewEtaNodeTypeWrapper (toJString $ show t) ptr

data EtaNodeTypeWrapper = EtaNodeTypeWrapper
  @com.typelead.intellij.plugin.eta.lang.psi.EtaNodeTypeWrapper
  deriving Class

type instance Inherits EtaNodeTypeWrapper = '[IElementType]

foreign import java unsafe "@new" unsafeNewEtaNodeTypeWrapper
  :: JString -> StablePtr EtaNodeType -> Java a EtaNodeTypeWrapper

foreign import java unsafe "@field tagPtr" tagPtr :: Java EtaNodeTypeWrapper (StablePtr EtaNodeType)
