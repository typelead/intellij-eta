package com.typelead.intellij.plugin.cabal.project.module;

import com.typelead.intellij.plugin.cabal.project.template.CabalComponentType;
import com.typelead.intellij.plugin.cabal.project.template.CabalFileData;

import javax.swing.*;

public class NewCabalProjectForm {

  private JPanel contentPane;
  private JCheckBox initializeCabalPackage;
  private JTextField version;
  private JTextField synopsis;
  private JTextField homepage;
  private JTextField authorName;
  private JTextField maintainerEmail;
  private JComboBox<String> category;
  private JTextField cabalVersion;
  private JComboBox<String> componentType;
  private JTextField sourceDir;
  private JComboBox<String> language;

  public JComponent getContentPane() {
    return contentPane;
  }

  public CabalFileData getData() {
    return new CabalFileData(
      initializeCabalPackage.isSelected(),
      version.getText(),
      synopsis.getText(),
      homepage.getText(),
      authorName.getText(),
      maintainerEmail.getText(),
      (String)category.getSelectedItem(),
      cabalVersion.getText(),
      CabalComponentType.valueOf((String) componentType.getSelectedItem()),
      sourceDir.getText(),
      (String)language.getSelectedItem()
    );
  }
}
