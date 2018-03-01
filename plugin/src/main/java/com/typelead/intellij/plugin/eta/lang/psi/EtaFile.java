package com.typelead.intellij.plugin.eta.lang.psi;

import com.intellij.extapi.psi.PsiFileBase;
import com.intellij.openapi.fileTypes.FileType;
import com.intellij.psi.FileViewProvider;
import com.typelead.intellij.plugin.eta.lang.EtaFileType;
import com.typelead.intellij.plugin.eta.lang.EtaLanguage;
import com.typelead.intellij.plugin.eta.resources.EtaIcons;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import javax.swing.*;

public final class EtaFile extends PsiFileBase {

    public EtaFile(@NotNull FileViewProvider viewProvider) {
        super(viewProvider, EtaLanguage.INSTANCE);
    }

    @NotNull
    @Override
    public FileType getFileType() {
        return EtaFileType.INSTANCE;
    }

    @Nullable
    @Override
    public Icon getIcon(int flags) {
        return EtaIcons.FILE;
    }

    @Override
    public String toString() {
        return "Eta file";
    }
}
