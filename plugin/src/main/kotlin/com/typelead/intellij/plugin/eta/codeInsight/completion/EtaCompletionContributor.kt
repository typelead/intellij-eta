package com.typelead.intellij.plugin.eta.codeInsight.completion

import com.intellij.codeInsight.completion.CompletionParameters
import com.intellij.codeInsight.completion.CompletionProvider
import com.intellij.codeInsight.completion.CompletionResultSet
import com.intellij.codeInsight.lookup.LookupElementBuilder
import com.intellij.psi.util.PsiTreeUtil
import com.intellij.util.ProcessingContext
import com.typelead.intellij.plugin.eta.ide.EtaIdeExecutor
import com.typelead.intellij.plugin.eta.ide.EtaIdeSettings
import com.typelead.intellij.plugin.eta.lang.psi.*
import com.typelead.intellij.plugin.eta.resources.EtaIcons

class EtaCompletionContributor : AbstractEtaCompletionContributor() {
  init {
    addProvider(EtaCompletionProvider())
  }
}

class EtaCompletionProvider : CompletionProvider<CompletionParameters>() {

  private val etaIde = EtaIdeExecutor(EtaIdeSettings(".", "eta-ide"))

  override fun addCompletions(
    parameters: CompletionParameters,
    context: ProcessingContext?,
    result: CompletionResultSet
  ) {
    val pos = parameters.position
    if (pos.parent is EtaPsiImportExplicit || pos.parent is EtaPsiImportHidden) {
      val imp = pos.parent.parent?.parent
      if (imp is EtaPsiImport) {
        val moduleName = PsiTreeUtil.getChildOfType(imp, EtaPsiImportModule::class.java)?.text
        if (moduleName != null) {
          etaIde.browse(moduleName).forEach { items ->
            val alreadyImported = PsiTreeUtil.getChildrenOfTypeAsList(pos.parent.parent, EtaPsiImportExplicit::class.java).map { it.text }.toSet()
            items.forEach { item ->
              if (!alreadyImported.contains(item.name)) {
                val name = if (item.isOp) "(${item.name})" else item.name
                result.addElement(
                  LookupElementBuilder
                    .create(name)
                    .withIcon(EtaIcons.FILE)
                    .withTypeText(item.type)
                )
              }
            }
          }
        }
      }
    }
  }
}
