module FFI.Com.IntelliJ.Lang.ParserDefinition
  ( ParserDefinition
  , SpaceRequirements
  ) where

import P
import FFI.Com.IntelliJ.Lang.ParserDefinition.SpaceRequirements

data {-# CLASS "com.intellij.lang.ParserDefinition" #-}
  ParserDefinition = ParserDefinition (Object# ParserDefinition)
  deriving Class
