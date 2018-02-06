package com.typelead.intellij.plugin.eta.lang;

import com.intellij.lang.Language;

public class EtaLanguage extends Language {

    public static final EtaLanguage INSTANCE = new EtaLanguage();

    private EtaLanguage() {
        super("Eta");
    }
}
