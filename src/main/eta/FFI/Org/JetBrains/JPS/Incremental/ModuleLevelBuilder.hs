module FFI.Org.JetBrains.JPS.Incremental.ModuleLevelBuilder where

import P

-- Start org.jetbrains.jps.incremental.ModuleLevelBuilder

data ModuleLevelBuilder = ModuleLevelBuilder @org.jetbrains.jps.incremental.ModuleLevelBuilder
  deriving Class

data ExitCode = ExitCode @org.jetbrains.jps.incremental.ModuleLevelBuilder$ExitCode
  deriving Class

foreign import java unsafe
  "@static @field org.jetbrains.jps.incremental.ModuleLevelBuilder.ExitCode.NOTHING_DONE"
  nothingDone :: ExitCode

foreign import java unsafe
  "@static @field org.jetbrains.jps.incremental.ModuleLevelBuilder.ExitCode.OK"
  ok :: ExitCode

data OutputConsumer = OutputConsumer @org.jetbrains.jps.incremental.ModuleLevelBuilder$OutputConsumer
  deriving Class


  -- End org.jetbrains.jps.incremental.ModuleLevelBuilder
