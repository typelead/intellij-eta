package com.typelead.intellij.utils;

import java.io.*;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.*;
import java.util.function.BiConsumer;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Utility for generating FFI definitions. Uses JVM properties for arguments.
 *
 * Required arguments -
 *  -Dclass=qualified.path.to.SomeClass   Fully-qualified path to Java class
 *
 * Optional arguments -
 *  -Dtarget=SomeType                     Target Eta type name
 *  -Dmethod=someMethod1,someMethod2      One or more method names to export, separated by commas
 *                                        If omitted, exports all method names
 *  -Dwrite                               Writes the output to the appropriate file in src/main/eta/FFI
 *  -Doverwrite                           Same as -Dwrite except writes regardless of existence.
 */
public class FFIGen {

  private static Map<String, TypeEntry> typeMapping =
    new TypeMappingBuilder()
      .put("java.lang.String", "JString", "Java")
      .put("boolean", "Bool", "Prelude")
      .put("boolean[]", "JBooleanArray", "Java")
      .put("java.lang.Boolean", "JBoolean", "Java")
      .put("byte", "Byte", "Java")
      .put("byte[]", "JByteArray", "Java")
      .put("java.lang.Byte", "JByte", "Java")
      .put("short", "Short", "Java")
      .put("short[]", "JShortArray", "Java")
      .put("java.lang.Short", "JShort", "Java")
      .put("char", "JChar", "Java")
      .put("char[]", "JCharArray", "Java")
      .put("java.lang.Char", "JCharacter", "Java")
      .put("int", "Int", "Prelude")
      .put("int[]", "JIntArray", "Java")
      .put("java.lang.Integer", "JInteger", "Java")
      .put("long", "Int64", "Data.Int")
      .put("long[]", "JLongArray", "Java")
      .put("java.lang.Long", "JLong", "Java")
      .put("float", "Float", "Prelude")
      .put("float[]", "JFloatArray", "Java")
      .put("java.lang.Float", "JFloat", "Java")
      .put("double", "Double", "Prelude")
      .put("double[]", "JDoubleArray", "Java")
      .put("java.lang.Double", "JDouble", "Java")
      .put("void", "()")
      .build();

  private static Map<String, String> packageMapping =
    new MapBuilder<String, String>()
      .put("intellij", "IntelliJ")
      .put("extapi", "ExtApi")
      .put("openapi", "OpenApi")
      .put("ui", "UI")
      .put("io", "IO")
      .put("typelead", "TypeLead")
      .build();

  private static Set<String> ignoredMethods = new HashSet<>(Arrays.asList(
    "equals",
    "toString",
    "hashCode",
    "wait",
    "getClass",
    "notify",
    "notifyAll"
  ));

  /////////////////////////////////////////////////////////////////

  public static void main(String[] args) {
    String clsName = System.getProperty("class");
    if (clsName == null) {
      throw new RuntimeException("Missing -Dclass=... argument");
    }
    Class cls;
    try {
      cls = Class.forName(clsName);
    } catch (Throwable e) {
      throw new IllegalArgumentException("Class not found: " + clsName);
    }

    final String etaDataName = System.getProperty("target", cls.getSimpleName());

    final Result result = new Result(cls, clsName, etaDataName);

    Function<Class, String> lookupEtaTypeAndAddImports = t -> {
      TypeEntry typeEntry = typeMapping.get(t.getName());
      if (typeEntry == null) {
        return t.getSimpleName();
      } else {
        result.imports.addAll(typeEntry.imports);
        return typeEntry.etaType;
      }
    };


    Function<Class[], List<String>> getArgTypes = paramTypes ->
      Arrays.stream(paramTypes).map(lookupEtaTypeAndAddImports).collect(Collectors.toList());

    Map<String, Integer> methodCounts = new HashMap<>();
    for (Method m : cls.getMethods()) {
      methodCounts.merge(m.getName(), 1, (a, b) -> a + b);
    }
    Map<String, Integer> counter = new HashMap<>();

    Set<String> onlyMethods = null;
    if (System.getProperty("method") != null) {
      onlyMethods =
        Arrays.stream(System.getProperty("method").split(","))
          .collect(Collectors.toSet());
    }

    BiConsumer<String, Constructor> addCtor = (name, c) ->
      result.ctors.add(new FFICtor(name, getArgTypes.apply(c.getParameterTypes()), etaDataName));
    // If we have more than 1 constructor, append an index to each exported name.
    if (cls.getConstructors().length == 1) {
      addCtor.accept("new" + etaDataName, cls.getConstructors()[0]);
    } else {
      for (int i = 0; i < cls.getConstructors().length; i++) {
        addCtor.accept("new" + etaDataName + i, cls.getConstructors()[i]);
      }
    }

    for (Method m : cls.getMethods()) {
      // Filter out methods we want to ignore.
      if (ignoredMethods.contains(m.getName())) continue;
      // If the user specified -Dmethod, only show those methods.
      if (onlyMethods != null && !onlyMethods.contains(m.getName())) continue;
      final String name;
      if (methodCounts.get(m.getName()) > 1) {
        name = m.getName() + counter.merge(m.getName(), 1, (a, b) -> a + b);
      } else {
        name = m.getName();
      }

      result.methods.add(
        new FFIMethod(
          m,
          name,
          getArgTypes.apply(m.getParameterTypes()),
          lookupEtaTypeAndAddImports.apply(m.getReturnType()),
          result.cls,
          etaDataName
        )
      );
    }

    PrintWriter pw;

    // If -D(over)write is specified, write to the appropriate file; otherwise, write to stdout.
    if (System.getProperty("write") != null || System.getProperty("overwrite") != null) {
      File file = new File(
        "plugin/src/main/eta/FFI" + "/" + String.join("/", result.getModulePath())
          + "/" + result.etaDataName + ".hs"
      );
      if (System.getProperty("overwrite") == null && file.exists()) {
        throw new IllegalArgumentException("File already exists: " + file.getPath());
      }
      try {
        //noinspection ResultOfMethodCallIgnored
        file.getParentFile().mkdirs();
        pw = new PrintWriter(new FileWriter(file));
      } catch (IOException e) {
        throw new RuntimeException(e);
      }
      System.out.println("Writing to file: " + file.getPath());
    } else {
      pw = new PrintWriter(System.out);
    }

    pw.println(result.render());

    pw.close();
  }

  private interface Renderable {
    String render();
  }

  private static class FFICtor implements Renderable {
    final String name;
    final List<String> argTypes;
    final String retType;

    FFICtor(String name, List<String> argTypes, String retType) {
      this.name = name;
      this.argTypes = argTypes;
      this.retType = retType;
    }

    @Override
    public String render() {
      StringBuilder sb = new StringBuilder();
      // foreign import java unsafe "@new" newTextFieldWithBrowseButton :: Java a TextFieldWithBrowseButton
      sb.append("foreign import java unsafe \"@new\" ").append(name).append("\n  :: ");
      argTypes.forEach(t -> sb.append(t).append(" -> "));
      sb.append("Java a ").append(retType);
      return sb.toString();
    }
  }

  private static class FFIMethod implements Renderable {
    final Method method;
    final String etaName;
    final List<String> argTypes;
    final String retType;
    final Class cls;
    final String etaDataName;

    FFIMethod(
      Method method, String etaName, List<String> argTypes, String retType,
      Class cls, String etaDataName
    ) {
      this.method = method;
      this.etaName = etaName;
      this.argTypes = argTypes;
      this.retType = retType;
      this.cls = cls;
      this.etaDataName = etaDataName;
    }

    @Override
    @SuppressWarnings("StringConcatenationInsideStringBufferAppend")
    public String render() {
      List<String> ffiStrParts = getFFIStringLitParts();
      StringBuilder sb = new StringBuilder();
      sb.append("foreign import java unsafe ");
      if (!ffiStrParts.isEmpty()) {
        sb.append('"').append(String.join(" ", ffiStrParts)).append('"').append(' ');
      }
      sb.append(etaName);
      sb.append("\n  :: ");
      argTypes.forEach(t -> sb.append(t).append(" -> "));
      sb.append("Java " + etaDataName + " " + retType);
      return sb.toString();
    }

    private List<String> getFFIStringLitParts() {
      if (Modifier.isStatic(method.getModifiers())) {
        return Collections.singletonList("@static " + cls.getName() + "." + method.getName());
      }
      List<String> res = new ArrayList<>();
      if (cls.isInterface()) res.add("@interface");
      if (!method.getName().equals(etaName)) res.add(method.getName());
      return res;
    }
  }

  private static class Result implements Renderable {
    final Class cls;
    final String clsName;
    final String etaDataName;
    final Set<String> imports = new HashSet<>();
    final List<FFICtor> ctors = new ArrayList<>();
    final List<FFIMethod> methods = new ArrayList<>();

    Result(Class cls, String clsName, String etaDataName) {
      this.cls = cls;
      this.clsName = clsName;
      this.etaDataName = etaDataName;
    }

    List<String> getModulePath() {
      return
        Arrays.stream(cls.getPackage().getName().split("\\."))
          .map(FFIGen::translatePackageName)
          .collect(Collectors.toList());
    }

    @Override
    @SuppressWarnings("StringConcatenationInsideStringBufferAppend")
    public String render() {
      StringBuilder sb = new StringBuilder();
      String moduleName = getModulePath().stream().reduce("FFI", (acc, s) -> acc + '.' + s);
      sb.append("module " + moduleName + "." + etaDataName + " where\n\n");
      imports.forEach(i -> sb.append("import " + i + "\n"));
      sb.append("\n");
      sb.append(
        "data " + etaDataName + " = " + etaDataName + "\n" +
          "  @" + clsName + "\n" +
          "  deriving Class\n\n"
      );
      Stream<Renderable> funcExports = Stream.concat(ctors.stream(), methods.stream());
      sb.append(String.join("\n\n", funcExports.map(Renderable::render).collect(Collectors.toList())));
      return sb.toString();
    }
  }

  /** Translate package name `s` using packageMapping; if it doesn't exist, just capitalize `s` */
  private static String translatePackageName(String s) {
    String res = packageMapping.get(s);
    if (res == null) res = Character.toUpperCase(s.charAt(0)) + s.substring(1);
    return res;
  }

  @SafeVarargs
  private static <A> Set<A> mkSet(A... values) {
    return new HashSet<>(Arrays.asList(values));
  }

  private static class TypeEntry {
    final String etaType;
    final Set<String> imports;

    TypeEntry(String etaType, String... imports) {
      this.etaType = etaType;
      this.imports = mkSet(imports);
    }
  }

  private static class MapBuilder<K, V> {

    private Map<K, V> map = new HashMap<>();

    public MapBuilder<K, V> put(K k, V v) {
      map.put(k, v);
      return this;
    }

    public Map<K, V> build() {
      return Collections.unmodifiableMap(map);
    }
  }

  private static class TypeMappingBuilder extends MapBuilder<String, TypeEntry> {
    public TypeMappingBuilder put(String javaType, String etaType, String... imports) {
      return (TypeMappingBuilder)super.put(javaType, new TypeEntry(etaType, imports));
    }
  }

}
