package com.typelead.intellij.plugin.cabal.project.module;

import com.typelead.intellij.plugin.cabal.project.template.CabalComponentType;
import com.typelead.intellij.plugin.cabal.project.template.CabalFileData;

import javax.swing.*;
import java.awt.event.ItemEvent;
import java.util.Arrays;

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

  public NewCabalProjectForm() {
    initializeCabalPackage.addItemListener(e -> {
      final Boolean enable;
      if (e.getStateChange() == ItemEvent.SELECTED) enable = true;
      else if (e.getStateChange() == ItemEvent.DESELECTED) enable = false;
      else enable = null;
      if (enable == null) return;
      Arrays.stream(contentPane.getComponents()).forEach(c -> {
        if (c != initializeCabalPackage) c.setEnabled(enable);
      });
    });
  }

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
