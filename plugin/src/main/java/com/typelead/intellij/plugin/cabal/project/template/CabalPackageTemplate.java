package com.typelead.intellij.plugin.cabal.project.template;

import com.intellij.ide.fileTemplates.FileTemplate;
import com.intellij.ide.fileTemplates.FileTemplateManager;
import com.intellij.ide.fileTemplates.FileTemplateUtil;
import com.intellij.openapi.diagnostic.Logger;
import com.intellij.psi.PsiDirectory;
import com.intellij.util.IncorrectOperationException;

import java.util.Properties;

public final class CabalPackageTemplate {

  private CabalPackageTemplate() {}

  private static Logger LOG = Logger.getInstance(CabalPackageTemplate.class);

  public static boolean createSetupFile(PsiDirectory psiDir) {
    return createFileFromTemplate(psiDir, "Setup.hs", "Default Setup Haskell File");
  }

  public static boolean createCabalFile(PsiDirectory psiDir, String name, CabalFileData data) {
    String templateName;
    if (data.componentType == CabalComponentType.Library) {
      templateName = "Default Library Cabal File";
    } else if (data.componentType == CabalComponentType.Executable) {
      templateName = "Default Executable Cabal File";
    } else {
      throw new IllegalArgumentException("Unexpected componentType: " + data.componentType);
    }
    return createFileFromTemplate(
      psiDir, name + ".cabal", templateName,
      "NAME", name,
      "PACKAGE_VERSION", data.packageVersion,
      "SYNOPSIS", data.synopsis,
      "HOMEPAGE", data.homepage,
      "AUTHOR", data.author,
      "MAINTAINER", data.maintainer,
      "CATEGORY", data.category,
      "CABAL_VERSION", data.cabalVersion,
      "SOURCE_DIR", data.sourceDir,
      "LANGAUGE", data.language
    );
  }

  public static boolean createHaskellMainFile(PsiDirectory psiDir) {
    return createFileFromTemplate(psiDir, "Main.hs", "Default Haskell Main File");
  }

  private static boolean createFileFromTemplate(
    PsiDirectory psiDir,
    String fileName,
    String templateName,
    String... kvps
  ) {
    if (kvps.length % 2 != 0) {
      throw new IllegalArgumentException("Invalid property arguments length: " + kvps.length);
    }
    try {
      psiDir.checkCreateFile(fileName);
    } catch (IncorrectOperationException e) {
      LOG.warn("Unable to create " + fileName + " in " + psiDir.getText() + ": " + e.getMessage(), e);
      return false;
    }
    FileTemplateManager templateManager = FileTemplateManager.getInstance(psiDir.getProject());
    FileTemplate template = templateManager.findInternalTemplate(templateName);
    Properties props = FileTemplateManager.getInstance(psiDir.getProject()).getDefaultProperties();
    for (int i = 0; i < kvps.length; ++i) {
      props.setProperty(kvps[i], kvps[i + 1]);
    }
    try {
      FileTemplateUtil.createFromTemplate(template, fileName, props, psiDir);
      return true;
    } catch (Exception e) {
      LOG.warn("Failed to create Setup.hs file in " + psiDir.getText() + ": " + e.getMessage(), e);
      return false;
    }
  }
}
