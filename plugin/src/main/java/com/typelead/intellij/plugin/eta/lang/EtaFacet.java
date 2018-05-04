package com.typelead.intellij.plugin.eta.lang;

import com.intellij.facet.Facet;
import com.intellij.facet.FacetConfiguration;
import com.intellij.facet.FacetType;
import com.intellij.openapi.module.Module;
import org.jetbrains.annotations.NotNull;

public class EtaFacet extends Facet {

  public EtaFacet(@NotNull Module module, @NotNull String name, @NotNull FacetConfiguration configuration, Facet underlyingFacet) {
    super(EtaFacetType.getInstance(), module, name, configuration, underlyingFacet);
  }
}
