package com.typelead.intellij.plugin.eta.project.template;

import com.intellij.facet.FacetConfiguration;
import com.intellij.facet.FacetManager;
import com.intellij.facet.ui.FacetEditorContext;
import com.intellij.facet.ui.FacetEditorTab;
import com.intellij.facet.ui.FacetValidatorsManager;
import com.intellij.framework.addSupport.FrameworkSupportInModuleConfigurable;
import com.intellij.openapi.module.Module;
import com.intellij.openapi.roots.ModifiableModelsProvider;
import com.intellij.openapi.roots.ModifiableRootModel;
import com.intellij.openapi.util.InvalidDataException;
import com.intellij.openapi.util.WriteExternalException;
import com.typelead.intellij.plugin.eta.lang.EtaFacet;
import com.typelead.intellij.plugin.eta.lang.EtaFacetType;
import org.jdom.Element;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import javax.swing.*;

public class EtaSupportConfigurable extends FrameworkSupportInModuleConfigurable {

  @Nullable
  @Override
  public JComponent createComponent() {
    return null;
  }

  @Override
  public void addSupport(
    @NotNull Module module,
    @NotNull ModifiableRootModel rootModel,
    @NotNull ModifiableModelsProvider modifiableModelsProvider
  ) {
    FacetManager.getInstance(module).addFacet(EtaFacetType.getInstance(), "Eta", null);
  }

  private static FacetConfiguration dummyFacetConfig = new FacetConfiguration() {
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
