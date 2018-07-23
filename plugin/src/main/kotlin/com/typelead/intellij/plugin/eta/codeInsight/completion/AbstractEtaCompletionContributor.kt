package com.typelead.intellij.plugin.eta.codeInsight.completion

import com.intellij.codeInsight.completion.CompletionContributor
import com.intellij.codeInsight.completion.CompletionParameters
import com.intellij.codeInsight.completion.CompletionProvider
import com.intellij.codeInsight.completion.CompletionType
import com.intellij.patterns.PlatformPatterns
import com.typelead.intellij.plugin.eta.lang.EtaLanguage

abstract class AbstractEtaCompletionContributor : CompletionContributor() {

  fun addProvider(p: CompletionProvider<CompletionParameters>) {
    extend(
      CompletionType.BASIC,
      PlatformPatterns.psiElement().withLanguage(EtaLanguage.INSTANCE),
      p
    )
  }
}
