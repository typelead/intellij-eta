package com.typelead.intellij.plugin.eta.settings;

import com.intellij.openapi.components.PersistentStateComponent;
import com.intellij.openapi.components.ServiceManager;
import com.intellij.openapi.components.State;
import com.intellij.openapi.components.Storage;
import com.intellij.openapi.project.Project;
import com.typelead.intellij.plugin.eta.jps.model.EtaBuildOptions;
import com.typelead.intellij.eta.jps.model.JpsEtaBuildOptionsConstants;
import org.jetbrains.annotations.Nullable;

/** Persistent state of Eta build settings for a project. */
@State(
  name = JpsEtaBuildOptionsConstants.ETA_BUILD_OPTIONS_COMPONENT,
  storages = {
    @Storage(JpsEtaBuildOptionsConstants.ETA_BUILD_OPTIONS_FILE)
  }
)
public class EtaBuildSettings implements PersistentStateComponent<EtaBuildOptions> {

//  // TODO: REMOVE
//  public static final EtaBuildSettings defaultInstance = getInstance(ProjectManager.getInstance().getDefaultProject());

  public static EtaBuildSettings getInstance(Project project) {
    EtaBuildSettings settings = ServiceManager.getService(project, EtaBuildSettings.class);
    return settings == null ? new EtaBuildSettings() : settings;
  }

  private EtaBuildOptions state = new EtaBuildOptions();

  @Nullable
  @Override
  public EtaBuildOptions getState() {
    return state;
  }

  @Override
  public void loadState(EtaBuildOptions state) {
    this.state = state;
  }

  public void setEtaPath(String s) {
    state.etaPath = s;
  }

  public String getEtaPath() {
    return state.etaPath;
  }

  public void setEtlasPath(String s) {
    state.etlasPath = s;
  }

  public String getEtlasPath() {
    return state.etlasPath;
  }
}
