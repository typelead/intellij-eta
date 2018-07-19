package com.typelead.intellij.plugin.eta.ide

import com.intellij.testFramework.UsefulTestCase
import junit.framework.TestCase

class EtaIdeExecutorTest : UsefulTestCase() {

  private val settings = EtaIdeSettings(
    workDir = System.getProperty("WORK_DIR") ?: ".",
    etaIdePath = System.getProperty("ETA_IDE") ?: "eta-ide"
  )

  private val VERSION = System.getProperty("ETA_IDE_VERSION") ?: "0.8.0.3"

  private fun mkEtaIde() = EtaIdeExecutor(settings)

  fun testWorks() {
    val etaIde = mkEtaIde()
    val version = etaIde.version().valueOr { throw it }
    TestCase.assertEquals(VERSION, version)
    val res1 = etaIde.browse("Control.Monad").valueOr { throw it }
    assertContainsElements(
      res1,
      BrowseItem("<$!>", true, "Monad m => (a -> b) -> m a -> m b"),
      BrowseItem("forever", false, "Monad m => m a -> m b"),
      BrowseItem("Monad", false, "class Monad m")
    )
    val res2 = etaIde.browse("Data.Void").valueOr { throw it }
    assertContainsElements(
      res2,
      BrowseItem("Void", false, "data Void"),
      BrowseItem("absurd", false, "Void -> a"),
      BrowseItem("vacuous", false, "Functor f => f Void -> f a")
    )
    etaIde.terminate()
  }
}
