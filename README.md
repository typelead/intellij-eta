# IntelliJ Eta

The IntelliJ IDEA plugin for the Eta programming language

## Prerequisities

You need `alex-3.2.3`. You can run `stack install alex-3.2.3` to obtain it with
the [Stack](https://docs.haskellstack.org/en/stable/README/) tool.

## Cloning

This repository has a submodule, so you should clone recursively.

```
git clone --recursive https://github.com/typelead/intellij-eta
```

If you forget to use the `--recursive` flag, you can still get the submodules.

```
cd intellij-eta
git submodule update --init --recursive
```

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
