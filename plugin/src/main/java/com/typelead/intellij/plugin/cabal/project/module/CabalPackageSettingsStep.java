package com.typelead.intellij.plugin.cabal.project.module;

import com.intellij.ide.util.projectWizard.ModuleBuilder;
import com.intellij.ide.util.projectWizard.ModuleWizardStep;
import com.intellij.ide.util.projectWizard.WizardContext;
import com.intellij.openapi.module.Module;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.roots.ModifiableRootModel;
import com.intellij.psi.PsiDirectory;
import com.intellij.psi.PsiManager;
import com.typelead.intellij.plugin.cabal.project.template.CabalFileData;
import com.typelead.intellij.plugin.cabal.project.template.CabalPackageTemplate;
import org.jetbrains.annotations.NotNull;

import javax.swing.*;

public class CabalPackageSettingsStep extends ModuleWizardStep {

  private final ModuleBuilder moduleBuilder;
  private final WizardContext wizardContext;
  private final NewCabalProjectForm form;

  public CabalPackageSettingsStep(
    ModuleBuilder moduleBuilder,
    WizardContext wizardContext,
    NewCabalProjectForm form
  ) {
    this.moduleBuilder = moduleBuilder;
    this.wizardContext = wizardContext;
    this.form = form;
  }

  @Override
  public void updateDataModel() {
    moduleBuilder.addModuleConfigurationUpdater(new ModuleBuilder.ModuleConfigurationUpdater() {
      @Override
      public void update(@NotNull Module module, @NotNull ModifiableRootModel rootModel) {
        updateModule(rootModel);
      }
    });
  }

  @Override
  public JComponent getComponent() {
    return form.getContentPane();
  }

  private void updateModule(ModifiableRootModel rootModel) {
    Project project = rootModel.getProject();
    CabalFileData data = form.getData();
    if (wizardContext.isCreatingNewProject() && data.initializeCabalPackage) {
      PsiDirectory psiDir = PsiManager.getInstance(project).findDirectory(project.getBaseDir());
      CabalPackageTemplate.createCabalFile(psiDir, project.getName(), data);
      CabalPackageTemplate.createSetupFile(psiDir);
    }
  }
}
