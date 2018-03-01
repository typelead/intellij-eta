package com.typelead.intellij.plugin.eta.project.template;

import com.intellij.framework.FrameworkTypeEx;
import com.intellij.framework.addSupport.FrameworkSupportInModuleProvider;
import com.typelead.intellij.plugin.eta.resources.EtaIcons;
import org.jetbrains.annotations.NotNull;

import javax.swing.*;

public class EtaFrameworkType extends FrameworkTypeEx {

  private EtaFrameworkType() {
    super("Eta");
  }

  private static EtaFrameworkType _instance = null;

  public static EtaFrameworkType getInstance() {
    if (_instance == null) _instance = FrameworkTypeEx.EP_NAME.findExtension(EtaFrameworkType.class);
    return _instance;
  }

  @NotNull
  @Override
  public FrameworkSupportInModuleProvider createProvider() {
    return new EtaSupportProvider();
  }

  @NotNull
  @Override
  public String getPresentableName() {
    return "Eta";
  }

  @NotNull
  @Override
  public Icon getIcon() {
    return EtaIcons.FILE;
  }
}
