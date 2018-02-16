# IntelliJ Eta

Eta language support for IntelliJ IDEA

## Building

The build currently relies on a local installation of the Eta Gradle plugin.
You will also need the command line tool [hpack](https://github.com/sol/hpack)

```
% ./gradlew assemble
```

## Running

You can run a sandboxed version of the plugin with:

```
./gradlew runIde
```

## Testing

```
./gradlew test
```
