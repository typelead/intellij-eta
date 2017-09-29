package com.typelead.intellij.plugin.eta.lang;

import com.intellij.openapi.fileTypes.LanguageFileType;
import com.typelead.intellij.plugin.eta.resources.EtaIcons;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import javax.swing.*;

public class EtaFileType extends LanguageFileType {

    public static final EtaFileType INSTANCE = new EtaFileType();

    private EtaFileType() {
        super(EtaLanguage.INSTANCE);
    }

    @NotNull
    @Override
    public String getName() {
        return "Eta";
    }

    @NotNull
    @Override
    public String getDescription() {
        return "Eta language file";
    }

    @NotNull
    @Override
    public String getDefaultExtension() {
        return "hs";
    }

    @Nullable
    @Override
    public Icon getIcon() {
        return EtaIcons.FILE;
    }
}
