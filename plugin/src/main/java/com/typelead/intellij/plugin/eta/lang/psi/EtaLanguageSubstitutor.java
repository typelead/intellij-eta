package com.typelead.intellij.plugin.eta.lang.psi;

import com.intellij.facet.FacetManager;
import com.intellij.lang.Language;
import com.intellij.openapi.module.Module;
import com.intellij.openapi.module.ModuleManager;
import com.intellij.openapi.module.ModuleType;
import com.intellij.openapi.module.ModuleUtilCore;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.util.io.FileUtilRt;
import com.intellij.openapi.vfs.VirtualFile;
import com.intellij.psi.LanguageSubstitutor;
import com.typelead.intellij.plugin.eta.lang.EtaFacetType;
import com.typelead.intellij.plugin.eta.lang.EtaLanguage;
import com.typelead.intellij.plugin.eta.project.module.EtlasModuleType;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.Collections;
import java.util.Set;

/**
 * Substitutes the Eta parser and syntax highlighter for Haskell files.
 * This happens if the Haskell file is in an Eta module (e.g. EtlasModuleType) or if the module
 * contains an EtaFacet.
 */
public class EtaLanguageSubstitutor extends LanguageSubstitutor {

  private static Set<String> extensions = Collections.singleton("hs");
  private static Set<ModuleType> etaModuleTypes = Collections.singleton(EtlasModuleType.getInstance());

  @Nullable
  @Override
  public Language getLanguage(@NotNull VirtualFile file, @NotNull Project project) {
    String ext = FileUtilRt.getExtension(file.getName());
    if (!extensions.contains(ext)) return null;
    Module module = ModuleUtilCore.findModuleForFile(file, project);
    if (module == null) return null;
    if (isEtaModule(module)) return EtaLanguage.INSTANCE;
    return null;
  }

  private boolean isEtaModule(@NotNull Module m) {
    return
      etaModuleTypes.contains(ModuleType.get(m))
      || hasEtaFacet(m)
      || parentHasEtaFacet(m);
  }

  private boolean hasEtaFacet(@NotNull Module m) {
    return FacetManager.getInstance(m).getFacetByType(EtaFacetType.ID) != null;
  }

  /**
   * If the user is using Gradle and is using the default setting of generating a module
   * per source set, we'll end up with generated module groups which do not have an EtaFacet
   * since they were generated. The parent module will however have an EtaFacet, so we can
   * look up the parent module by the module group name (both should be identical).
   */
  private boolean parentHasEtaFacet(@NotNull Module m) {
    String[] path = ModuleManager.getInstance(m.getProject()).getModuleGroupPath(m);
    // In our case, we're expecting a singleton array with the name of the parent module.
    if (path != null && path.length == 1) {
      Module parent = ModuleManager.getInstance(m.getProject()).findModuleByName(path[0]);
      if (parent != null) return hasEtaFacet(parent);
    }
    return false;
  }
}
