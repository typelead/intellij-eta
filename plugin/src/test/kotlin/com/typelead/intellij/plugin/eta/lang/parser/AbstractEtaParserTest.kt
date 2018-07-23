package com.typelead.intellij.plugin.eta.lang.parser

import com.intellij.psi.PsiFile
import com.intellij.testFramework.ParsingTestCase
import com.typelead.intellij.plugin.eta.lang.parser.EtaParserDefinition

abstract class AbstractEtaParserTest : ParsingTestCase(
  DATA_PATH, FILE_EXT, false, DEFINITION
) {

  fun doTest() = doTest(true)

  override fun skipSpaces() = true

  override fun checkResult(targetDataName: String, file: PsiFile) =
    doCheckResult(
      myFullDataPath, file, checkAllPsiRoots(),
      "$EXPECT_PATH/$targetDataName", skipSpaces(), includeRanges()
    )

  override fun getTestDataPath(): String = FIXTURE_PATH

  companion object {
    val FIXTURE_PATH = "src/test/resources/fixtures/eta"
    val DATA_PATH = "sources"
    val EXPECT_PATH = "parser"
    val FILE_EXT = "hs"
    val DEFINITION = EtaParserDefinition()
  }
}
