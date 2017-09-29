module FFI.Com.IntelliJ.Lang.ParserDefinition.SpaceRequirements where

import P

data {-# CLASS "com.intellij.lang.ParserDefinition.SpaceRequirements" #-}
  SpaceRequirements = SpaceRequirements (Object# SpaceRequirements)
  deriving Class

type instance Inherits SpaceRequirements = '[JavaEnum SpaceRequirements]

foreign import java unsafe
  "@static @field com.intellij.lang.ParserDefinition.SpaceRequirements.MAY"
  may :: SpaceRequirements

foreign import java unsafe
  "@static @field com.intellij.lang.ParserDefinition.SpaceRequirements.MUST"
  must :: SpaceRequirements

foreign import java unsafe
  "@static @field com.intellij.lang.ParserDefinition.SpaceRequirements.MUST_NOT"
  mustNot :: SpaceRequirements

foreign import java unsafe
  "@static @field com.intellij.lang.ParserDefinition.SpaceRequirements.MUST_LINE_BREAK"
  mustLineBreak :: SpaceRequirements
