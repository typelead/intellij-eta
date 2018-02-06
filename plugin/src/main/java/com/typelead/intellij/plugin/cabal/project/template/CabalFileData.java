package com.typelead.intellij.plugin.cabal.project.template;

public class CabalFileData {

  public final boolean initializeCabalPackage;
  public final String packageVersion;
  public final String synopsis;
  public final String homepage;
  public final String author;
  public final String maintainer;
  public final String category;
  public final String cabalVersion;
  public final CabalComponentType componentType;
  public final String sourceDir;
  public final String language;

  public CabalFileData(
    boolean initializeCabalPackage,
    String packageVersion,
    String synopsis,
    String homepage,
    String author,
    String maintainer,
    String category,
    String cabalVersion,
    CabalComponentType componentType,
    String sourceDir,
    String language
  ) {
    this.initializeCabalPackage = initializeCabalPackage;
    this.packageVersion = packageVersion;
    this.synopsis = synopsis;
    this.homepage = homepage;
    this.author = author;
    this.maintainer = maintainer;
    this.category = category;
    this.cabalVersion = cabalVersion;
    this.componentType = componentType;
    this.sourceDir = sourceDir;
    this.language = language;
  }
}
