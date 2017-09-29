package com.typelead.intellij.plugin.eta.lang.psi;

import com.intellij.openapi.fileTypes.FileTypeConsumer;
import com.intellij.openapi.fileTypes.FileTypeFactory;
import com.typelead.intellij.plugin.eta.lang.EtaFileType;
import org.jetbrains.annotations.NotNull;

public class EtaFileTypeFactory extends FileTypeFactory {
    @Override
    public void createFileTypes(@NotNull FileTypeConsumer consumer) {
        consumer.consume(EtaFileType.INSTANCE, "hs");
    }
}
