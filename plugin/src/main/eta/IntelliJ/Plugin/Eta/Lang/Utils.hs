{-# OPTIONS_GHC -fno-warn-missing-fields #-}
module IntelliJ.Plugin.Eta.Lang.Utils where

import P
import Language.Eta.Main.DynFlags

-- | Default flags which can be used to initialize the Eta Lexer.
-- Adapted from Language.Eta.Parser.Lexer.lexTokenStream
defaultFlags :: DynFlags
defaultFlags =
    flip gopt_set Opt_KeepRawTokenStream
  . flip gopt_unset Opt_EtaDoc
  $ flags
  where
  -- | Note: We're omitting the DynFlags we shouldn't need. If one is
  -- accessed that isn't defined, we'll get an exception at runtime.
  -- Warnings suppressed with -fno-warn-missing-fields
  flags = DynFlags
    { generalFlags = mempty
    , safeHaskell = Sf_None
    , extensions = mempty
    , extensionFlags = mempty
    , language = Nothing
    }
