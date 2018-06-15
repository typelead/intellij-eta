package com.typelead.intellij.plugin.eta.lang;

import com.intellij.lang.Language;
import com.intellij.openapi.fileTypes.LanguageFileType;
import org.jetbrains.annotations.Nullable;

public class EtaLanguage extends Language {

  public static final EtaLanguage INSTANCE = new EtaLanguage();

  private EtaLanguage() {
    super("Eta");
  }

  @Nullable
  @Override
  public LanguageFileType getAssociatedFileType() {
    return EtaFileType.INSTANCE;
  }
}
