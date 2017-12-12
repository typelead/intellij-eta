package com.typelead.intellij.utils;

import java.util.function.Function;
import java.util.function.Supplier;

public abstract class JavaUtil {

    public static final Object unsafeNull = null;

    public static final String emptyJString = "";

    public static void throwJava(Throwable t) throws Throwable {
        throw t;
    }

    public static <A, E extends Throwable> A tryJava(
            Class<E> catchCls,
            Supplier<A> supplier,
            Function<E, A> onCatch
    ) {
        try {
            return supplier.get();
        } catch (Throwable e) {
            if (catchCls.isInstance(e)) return onCatch.apply(catchCls.cast(e));
            throw e;
        }
    }
}
