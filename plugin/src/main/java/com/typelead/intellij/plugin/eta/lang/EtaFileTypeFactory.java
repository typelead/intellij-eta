package com.typelead.intellij.plugin.eta.lang;

import com.intellij.ide.plugins.PluginManager;
import com.intellij.openapi.extensions.PluginId;
import com.intellij.openapi.fileTypes.ExtensionFileNameMatcher;
import com.intellij.openapi.fileTypes.FileNameMatcher;
import com.intellij.openapi.fileTypes.FileTypeConsumer;
import com.intellij.openapi.fileTypes.FileTypeFactory;
import org.jetbrains.annotations.NotNull;

public class EtaFileTypeFactory extends FileTypeFactory {

  @Override
  public void createFileTypes(@NotNull FileTypeConsumer consumer) {
    consumer.consume(EtaFileType.INSTANCE, getMyFileNameMatcher());
  }

  private static FileNameMatcher getMyFileNameMatcher() {
    if (PluginManager.isPluginInstalled(PluginId.getId("com.haskforce"))) {
      return noFileNameMatcher();
    }
    return new ExtensionFileNameMatcher("hs");
  }

  private static FileNameMatcher noFileNameMatcher() {
    return new FileNameMatcher() {
      @Override
      public boolean accept(@NotNull String fileName) {
        return false;
      }

      @NotNull
      @Override
      public String getPresentableString() {
        return "none";
      }
    };
  }
}
