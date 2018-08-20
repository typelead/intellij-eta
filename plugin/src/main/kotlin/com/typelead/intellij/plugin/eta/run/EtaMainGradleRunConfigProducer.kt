package com.typelead.intellij.plugin.eta.run

import com.intellij.execution.actions.ConfigurationContext
import com.intellij.execution.actions.RunConfigurationProducer
import com.intellij.openapi.externalSystem.service.execution.ExternalSystemRunConfiguration
import com.intellij.openapi.util.Key
import com.intellij.openapi.util.Ref
import com.intellij.psi.PsiDirectory
import com.intellij.psi.PsiElement
import com.intellij.psi.PsiFile
import org.jetbrains.plugins.gradle.service.execution.GradleExternalTaskConfigurationType
import java.util.regex.Pattern

class EtaMainGradleRunConfigProducer : RunConfigurationProducer<ExternalSystemRunConfiguration>(
  GradleExternalTaskConfigurationType.getInstance()
) {

  override fun setupConfigurationFromContext(
    configuration: ExternalSystemRunConfiguration,
    context: ConfigurationContext,
    sourceElement: Ref<PsiElement>
  ): Boolean {
    if (!isValidMain(sourceElement.get())) return false
    // Modify run configuration properties
    configuration.name = context.module.name
    configuration.settings.externalProjectPath = context.project.basePath
    configuration.settings.taskNames.add("run")
    // Dummy key so `isConfigurationFromContext` can tell if this configuration is from us or not.
    configuration.putUserData(USER_DATA_KEY, true)
    return true
  }

  private fun isValidMain(el: PsiElement): Boolean {
    val psiFile = el.containingFile ?: return false
    val path = psiFile.virtualFile?.canonicalPath
    if (path == null || !path.endsWith(MAIN_PATH)) return false
    val buildScript = findBuildScript(psiFile.parent)
    return buildScript != null && hasApplicationPlugin(buildScript)
  }

  override fun isConfigurationFromContext(
    configuration: ExternalSystemRunConfiguration,
    context: ConfigurationContext
  ): Boolean = configuration.getUserData(USER_DATA_KEY) ?: false

  private fun hasApplicationPlugin(file: PsiFile): Boolean =
    APPLICATION_PLUGIN_REGEX.matcher(file.text).find()

  private fun findBuildScript(dir: PsiDirectory?): PsiFile? {
    if (dir == null) return null
    return dir.findFile("build.gradle") ?: findBuildScript(dir.parent)
  }

  companion object {
    const val MAIN_PATH = "/src/main/eta/Main.hs"
    val APPLICATION_PLUGIN_REGEX: Pattern = Pattern.compile("\\b(id|apply plugin:) 'application'")
    val USER_DATA_KEY: Key<Boolean> = Key(EtaMainGradleRunConfigProducer::class.java.simpleName)
  }
}
