package com.typelead.intellij.plugin.eta.actions

import com.intellij.ide.actions.CreateFileFromTemplateAction
import com.intellij.ide.actions.CreateFileFromTemplateDialog
import com.intellij.ide.fileTemplates.FileTemplate
import com.intellij.ide.fileTemplates.FileTemplateManager
import com.intellij.ide.fileTemplates.FileTemplateUtil
import com.intellij.openapi.fileEditor.FileEditorManager
import com.intellij.openapi.module.ModuleUtilCore
import com.intellij.openapi.project.Project
import com.intellij.openapi.roots.ModuleRootManager
import com.intellij.openapi.ui.InputValidatorEx
import com.intellij.psi.PsiDirectory
import com.intellij.psi.PsiFile
import com.typelead.intellij.plugin.eta.resources.EtaIcons
import java.util.regex.Pattern

class CreateEtaFileAction : CreateFileFromTemplateAction(TITLE, DESCRIPTION, EtaIcons.FILE) {

  override fun getActionName(directory: PsiDirectory, newName: String, templateName: String): String = TITLE

  override fun buildDialog(project: Project, directory: PsiDirectory, builder: CreateFileFromTemplateDialog.Builder) {
    builder
      .setTitle(TITLE)
      .addKind("Empty module", EtaIcons.FILE, ETA_MODULE_TEMPLATE_NAME)
      .setValidator(MyInputValidator)
  }

  // We can't seem to set custom properties via any of the `createFileFromTemplate` methods,
  // so we have to roll our own. Adapted from HaskForce's CreateHaskellFileAction.
  override fun createFileFromTemplate(name: String, template: FileTemplate, dir: PsiDirectory): PsiFile? {
    val project = dir.project
    val qualifiedName = getQualifiedName(name)
    val fileName = buildFileName(qualifiedName)
    val targetDir = createTargetSubDir(qualifiedName, dir)
    val props = FileTemplateManager.getInstance(project).defaultProperties
    val moduleName = determineFullyQualifiedModuleName(qualifiedName, dir)
    props.setProperty("ETA_MODULE_NAME", moduleName)
    val psiFile = FileTemplateUtil.createFromTemplate(template, fileName, props, targetDir).containingFile
    if (psiFile.virtualFile != null) FileEditorManager.getInstance(project).openFile(psiFile.virtualFile, true)
    return psiFile
  }

  private fun getQualifiedName(name: String): String =
    if (name.endsWith(".hs")) name.substring(0, name.lastIndexOf('.')) else name

  private fun createTargetSubDir(qualifiedName: String, dir: PsiDirectory): PsiDirectory {
    if (!qualifiedName.contains('.')) return dir
    var targetDir = dir
    qualifiedName.split('.').dropLast(1).forEach { part ->
      val found = targetDir.findSubdirectory(part)
      targetDir = if (found != null) found else targetDir.createSubdirectory(part)
    }
    return targetDir
  }

  private fun buildFileName(qualifiedName: String): String =
    qualifiedName.substring(qualifiedName.lastIndexOf('.') + 1) + ".hs"

  /** Performs best guess for the fully-qualified module name based on the user-supplied qualifiedName and directory. */
  private fun determineFullyQualifiedModuleName(qualifiedName: String, dir: PsiDirectory): String {
    val module = ModuleUtilCore.findModuleForFile(dir.virtualFile, dir.project) ?: return qualifiedName
    val sourceRoots = ModuleRootManager.getInstance(module).sourceRoots.map { it.canonicalPath }.toSet()
    val prefix = ArrayList<String>()
    var checkDir: PsiDirectory = dir
    while (!sourceRoots.contains(checkDir.virtualFile.canonicalPath)) {
      prefix.add(0, checkDir.name)
      checkDir = checkDir.parent ?: return qualifiedName
    }
    if (prefix.isEmpty()) return qualifiedName
    return prefix.joinToString(".") + "." + qualifiedName
  }

  companion object {
    val TITLE = "New Eta File"
    val DESCRIPTION = "Creates a new Eta source file"
    val ETA_MODULE_TEMPLATE_NAME = "Eta Module"
    val VALID_NAME_REGEX = Pattern.compile("^([A-Z][A-Za-z0-9]*)(\\.[A-Z][A-Za-z0-9]*)*(\\.hs)?$")

    private object MyInputValidator : InputValidatorEx {

      override fun checkInput(input: String): Boolean = true

      override fun canClose(input: String): Boolean = getErrorText(input) == null

      override fun getErrorText(input: String): String? {
        if (input.isEmpty()) return null
        if (VALID_NAME_REGEX.matcher(input).matches()) return null
        return "'$input' is not a valid Eta module name."
      }
    }
  }
}
