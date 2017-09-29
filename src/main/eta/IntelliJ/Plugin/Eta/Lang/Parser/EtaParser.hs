module IntelliJ.Plugin.Eta.Lang.Parser.EtaParser where

import P

data {-# CLASS "com.typelead.intellij.plugin.eta.lang.parser.EtaParser extends com.typelead.intellij.utils.parser.SimplePsiParser" #-}
  EtaParser = EtaParser (Object# EtaParser)
  deriving Class

foreign import java unsafe "@new" newEtaParser :: Java a EtaParser
