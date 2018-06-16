package com.typelead.intellij.plugin.eta.lang.psi;

import com.intellij.facet.FacetManager;
import com.intellij.lang.Language;
import com.intellij.openapi.module.Module;
import com.intellij.openapi.module.ModuleType;
import com.intellij.openapi.module.ModuleUtilCore;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.util.io.FileUtilRt;
import com.intellij.openapi.vfs.VirtualFile;
import com.intellij.psi.LanguageSubstitutor;
import com.typelead.intellij.plugin.eta.lang.EtaFacet;
import com.typelead.intellij.plugin.eta.lang.EtaFacetType;
import com.typelead.intellij.plugin.eta.lang.EtaLanguage;
import com.typelead.intellij.plugin.eta.project.module.EtlasModuleType;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.Collections;
import java.util.Set;

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
      || FacetManager.getInstance(m).getFacetByType(EtaFacetType.ID) != null;
  }
}
