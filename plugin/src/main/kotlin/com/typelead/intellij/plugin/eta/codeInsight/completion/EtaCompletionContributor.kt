package com.typelead.intellij.plugin.eta.codeInsight.completion

import com.intellij.codeInsight.completion.CompletionParameters
import com.intellij.codeInsight.completion.CompletionProvider
import com.intellij.codeInsight.completion.CompletionResultSet
import com.intellij.codeInsight.lookup.LookupElementBuilder
import com.intellij.psi.util.PsiTreeUtil
import com.intellij.util.ProcessingContext
import com.typelead.intellij.plugin.eta.ide.BrowseItem
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
  private val browseItemCache = HashMap<String, List<BrowseItem>>()

  override fun addCompletions(
    parameters: CompletionParameters,
    context: ProcessingContext?,
    result: CompletionResultSet
  ) = EtaCompleter(etaIde, browseItemCache, parameters, context, result).complete()
}
class EtaCompleter(
  val etaIde: EtaIdeExecutor,
  val browseItemCache: HashMap<String, List<BrowseItem>>,
  val parameters: CompletionParameters,
  val context: ProcessingContext?,
  val result: CompletionResultSet
) {

  val pos = parameters.position

  fun complete() {
    maybeClearCache()
    completeImportTerm()
  }

  // Clear the browseItemCache if the user pressed ctrl+space multiple times, this way we will
  // invoke eta-ide again in case things changed.
  fun maybeClearCache() {
    if (parameters.invocationCount > 0) browseItemCache.clear()
  }

  fun completeImportTerm(): Boolean {
    if (!(pos.parent is EtaPsiImportExplicit || pos.parent is EtaPsiImportHidden)) return false
    val imp = pos.parent.parent?.parent
    if (imp !is EtaPsiImport) return false
    val moduleName = PsiTreeUtil.getChildOfType(imp, EtaPsiImportModule::class.java)?.text
    if (moduleName == null) return false
    val cacheItems = browseItemCache.get(moduleName)
    val items = if (cacheItems == null) {
      etaIde.browse(moduleName).fold(
        { e -> null },
        { items ->
          browseItemCache.put(moduleName, items)
          items
        }
      )
    } else {
      cacheItems
    }
    if (items == null) return true
    val alreadyImported = PsiTreeUtil.getChildrenOfTypeAsList(
      pos.parent.parent,
      EtaPsiImportExplicit::class.java
    ).map { it.text }.toSet()
    items.forEach { item ->
      if (!alreadyImported.contains(item.name)) {
        val name = if (item.isOp) "(${item.name})" else item.name
        add(name, item.type)
      }
    }
    return true
  }

  fun add(name: String, type: String) = result.addElement(
    LookupElementBuilder
      .create(name)
      .withIcon(EtaIcons.FILE)
      .withTypeText(type)
  )
}
