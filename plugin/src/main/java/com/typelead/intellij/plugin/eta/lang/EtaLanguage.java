package com.typelead.intellij.plugin.eta.lang;

import com.intellij.lang.Language;
import com.intellij.openapi.fileTypes.LanguageFileType;
import org.jetbrains.annotations.NotNull;

public class EtaLanguage extends Language {

  public static final EtaLanguage INSTANCE = new EtaLanguage();

  private EtaLanguage() {
    super("Eta");
  }

  @NotNull
  @Override
  public LanguageFileType getAssociatedFileType() {
    return EtaFileType.INSTANCE;
  }
}
