package com.typelead.intellij.utils;

public abstract class JavaUtil {

    public static final Object unsafeNull = null;

    public static final String emptyJString = "";

    public static <A> A throwJava(Throwable t) throws Throwable {
        throw t;
    }
}
