# IntelliJ Eta

The IntelliJ IDEA plugin for the Eta programming language

## Building

```
% ./gradlew :plugin:assemble
```

## Running

You can run a sandboxed version of the plugin with:

```
./gradlew :plugin:runIde
```

You can supply the `-DETAJ_DEV=1` property to have the sandboxed IDE run
with the PsiViewer plugin installed. This is useful for inspecting parse trees.

## Testing

```
./gradlew :plugin:test
```
