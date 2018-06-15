package com.typelead.intellij.plugin.eta.lang;

import com.intellij.openapi.module.ModuleType;
import com.intellij.openapi.module.ModuleTypeId;

public abstract class EtaModuleSupportUtil {
  private EtaModuleSupportUtil() {}

  public static boolean isSuitableEtaModuleType(ModuleType moduleType) {
    String id = moduleType.getId();
    return ModuleTypeId.JAVA_MODULE.equals(id) || "PLUGIN_MODULE".equals(id);
  }
}
