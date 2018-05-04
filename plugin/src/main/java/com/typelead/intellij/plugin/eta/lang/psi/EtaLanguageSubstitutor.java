package com.typelead.intellij.plugin.eta.lang.psi;

import com.intellij.facet.FacetManager;
import com.intellij.lang.Language;
import com.intellij.openapi.module.Module;
import com.intellij.openapi.module.ModuleUtilCore;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.util.io.FileUtilRt;
import com.intellij.openapi.vfs.VirtualFile;
import com.intellij.psi.LanguageSubstitutor;
import com.typelead.intellij.plugin.eta.lang.EtaFacet;
import com.typelead.intellij.plugin.eta.lang.EtaFacetType;
import com.typelead.intellij.plugin.eta.lang.EtaLanguage;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

public class EtaLanguageSubstitutor extends LanguageSubstitutor {

  private static Set<String> extensions = new HashSet<>(Collections.singletonList("hs"));

  @Nullable
  @Override
  public Language getLanguage(@NotNull VirtualFile file, @NotNull Project project) {
    String ext = FileUtilRt.getExtension(file.getName());
    if (!extensions.contains(ext)) return null;
    Module module = ModuleUtilCore.findModuleForFile(file, project);
    if (module == null) return null;
    EtaFacet facet = FacetManager.getInstance(module).getFacetByType(EtaFacetType.ID);
    if (facet == null) return null;
    return EtaLanguage.INSTANCE;
  }
}
