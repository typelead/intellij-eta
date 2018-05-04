package com.typelead.intellij.plugin.eta.lang;

import com.intellij.facet.Facet;
import com.intellij.facet.FacetConfiguration;
import com.intellij.facet.FacetType;
import com.intellij.facet.FacetTypeId;
import com.intellij.facet.ui.DefaultFacetSettingsEditor;
import com.intellij.facet.ui.FacetEditorContext;
import com.intellij.facet.ui.FacetEditorTab;
import com.intellij.facet.ui.FacetValidatorsManager;
import com.intellij.openapi.module.Module;
import com.intellij.openapi.module.ModuleType;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.util.InvalidDataException;
import com.intellij.openapi.util.WriteExternalException;
import com.typelead.intellij.plugin.eta.resources.EtaIcons;
import org.jdom.Element;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import javax.swing.*;

public class EtaFacetType extends FacetType<EtaFacet, FacetConfiguration> {

  private static String STRING_ID = "ETA_FACET";
  public static FacetTypeId<EtaFacet> ID = new FacetTypeId<>(STRING_ID);
  private static EtaFacetType _instance = null;

  public static EtaFacetType getInstance() {
    if (_instance == null) _instance = EP_NAME.findExtension(EtaFacetType.class);
    return _instance;
  }

  EtaFacetType() {
    super(ID, STRING_ID, "Eta");
  }

  @Override
  public FacetConfiguration createDefaultConfiguration() {
    // TODO
    return new FacetConfiguration() {
      @Override
      public FacetEditorTab[] createEditorTabs(FacetEditorContext editorContext, FacetValidatorsManager validatorsManager) {
        return new FacetEditorTab[0];
      }

      @Override
      public void readExternal(Element element) throws InvalidDataException {}

      @Override
      public void writeExternal(Element element) throws WriteExternalException {}
    };
  }

  @Override
  public EtaFacet createFacet(@NotNull Module module, String name, @NotNull FacetConfiguration configuration, @Nullable Facet underlyingFacet) {
    return new EtaFacet(module, name, configuration, underlyingFacet);
  }

  @Override
  public boolean isSuitableModuleType(ModuleType moduleType) {
    return EtaModuleSupportUtil.isSuitableEtaModuleType(moduleType);
  }

  @Nullable
  @Override
  public Icon getIcon() {
    return EtaIcons.FILE;
  }
}
