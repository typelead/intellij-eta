package com.typelead.intellij.utils;

/** Port of scala.util.control.NonFatal */
public abstract class NonFatal {

  /** Returns `true` if the Throwable is nonfatal; `false` otherwise. */
  public static boolean apply(Throwable e) {
    return !(
         e instanceof VirtualMachineError
      || e instanceof ThreadDeath
      || e instanceof InterruptedException
      || e instanceof LinkageError
    );
  }
}
