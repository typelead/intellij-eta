package com.typelead.intellij.plugin.eta;

import com.haskforce.core.HaskForceCoreMeta;
import com.intellij.notification.Notification;
import com.intellij.notification.NotificationType;
import com.intellij.notification.Notifications;
import com.intellij.openapi.components.ApplicationComponent;

public class IntelliJEtaPluginVerifier implements ApplicationComponent {

  @Override
  public void initComponent() {
    String expectedCoreVersion = IntelliJEtaMeta.CORE_VERSION;
    String actualCoreVersion = HaskForceCoreMeta.VERSION;
    if (!expectedCoreVersion.equals(actualCoreVersion)) {
      Notifications.Bus.notify(
        new Notification(
          "Eta plugin compatibility",
          "Eta plugin compatibility",
          "IntelliJ-Eta depends on the haskforce-core library version " + expectedCoreVersion
            + "; however, version " + actualCoreVersion + " was found. Another Haskell plugin "
            + "(possibly HaskForce) may be overriding this library. "
            + "Functionality may not work as expected.",
          NotificationType.WARNING
        )
      );
    }
  }
}
