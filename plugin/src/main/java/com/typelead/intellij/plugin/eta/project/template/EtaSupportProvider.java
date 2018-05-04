package com.typelead.intellij.plugin.eta.project.template;

import com.intellij.framework.FrameworkTypeEx;
import com.intellij.framework.addSupport.FrameworkSupportInModuleConfigurable;
import com.intellij.framework.addSupport.FrameworkSupportInModuleProvider;
import com.intellij.ide.util.frameworkSupport.FrameworkSupportModel;
import com.intellij.openapi.module.ModuleType;
import com.intellij.openapi.module.ModuleTypeId;
import com.typelead.intellij.plugin.eta.lang.EtaModuleSupportUtil;
import com.typelead.intellij.plugin.eta.resources.EtaIcons;
import org.jetbrains.annotations.NotNull;

import javax.swing.*;

public class EtaSupportProvider extends FrameworkSupportInModuleProvider {

  @Override
  public Icon getIcon() {
    return EtaIcons.FILE;
  }

  @NotNull
  @Override
  public FrameworkTypeEx getFrameworkType() {
    return EtaFrameworkType.getInstance();
  }

  @NotNull
  @Override
  public FrameworkSupportInModuleConfigurable createConfigurable(@NotNull FrameworkSupportModel model) {
    return new EtaSupportConfigurable();
  }

  @Override
  public boolean isEnabledForModuleType(@NotNull ModuleType moduleType) {
    return EtaModuleSupportUtil.isSuitableEtaModuleType(moduleType);
  }
}
