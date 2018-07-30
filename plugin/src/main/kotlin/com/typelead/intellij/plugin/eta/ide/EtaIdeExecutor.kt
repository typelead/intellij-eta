package com.typelead.intellij.plugin.eta.ide

import com.google.gson.*
import com.intellij.execution.configurations.GeneralCommandLine
import com.typelead.intellij.utils.Either
import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.InputStreamReader
import java.io.OutputStreamWriter

data class EtaIdeSettings(
  val workDir: String,
  val etaIdePath: String
)

class EtaIdeExecutor(private val settings: EtaIdeSettings) {

  fun terminate(): Either<Throwable, Unit> =
    getProcess().map { it.kill() }

  fun version(): Either<Throwable, String> =
    getProcess().map { it.getVersion() }

  fun browse(module: String): Either<Throwable, List<BrowseItem>> =
    exec(":idebrowse $module")
      .flatMap(IdeResponse.fromJsonOfBrowseItems)
      .map { it.result }

  fun exec(command: String): Either<Throwable, String> =
    getProcess().flatMap { it.interact(command) }

  private var unsafeProcess: EtaIdeProcess? = null

  private fun getProcess(): Either<Throwable, EtaIdeProcess> =
    if (unsafeProcess != null) Either.right(unsafeProcess)
    else EtaIdeProcess.spawn(settings).map { p -> unsafeProcess = p; p }
}

class EtaIdeProcess private constructor(
  private val process: Process,
  private val input: BufferedReader,
  private val output: BufferedWriter
) {

  private var version: String? = null

  private fun init(): Either<Throwable, EtaIdeProcess> =
    interact(":version")
      .flatMap(IdeResponse.fromJsonOfString)
      .map { response ->
        version = response.result
        this
      }

  fun getVersion(): String =
    version ?: throw IllegalStateException("version is uninitialized")

  fun interact(command: String): Either<Throwable, String> =
    write(command).then { read() }

  fun kill(): Unit {
    Either.catchNonFatal { process.destroy() }
    Either.catchNonFatal { input.close() }
    Either.catchNonFatal { output.close() }
  }

  private fun write(command: String): Either<Throwable, Unit> =
    Either.catchNonFatal {
      output.write(command)
      output.newLine()
      output.flush()
    }.leftMap { e ->
      val message = read().toOptional().filter { it.trim().isNotEmpty() }.orElse(e.toString())
      ExecError(command, message, e)
    }

  private fun read(): Either<Throwable, String> =
    Either.catchNonFatal { input.readLine() }

  companion object {

    class ExecError(command: String, message: String, cause: Throwable?)
      : Exception("Executing eta-ide command '$command' failed: $message", cause)

    fun spawn(settings: EtaIdeSettings): Either<Throwable, EtaIdeProcess> =
      Either.catchNonFatal {
        GeneralCommandLine()
           .withExePath(settings.etaIdePath)
           .withParameters("-fdiagnostics-color=never")
           .withWorkDirectory(settings.workDir)
           .withRedirectErrorStream(true)
           .createProcess()
      }.flatMap { process ->
         EtaIdeProcess(
           process = process,
           input   = BufferedReader(InputStreamReader(process.inputStream)),
           output  = BufferedWriter(OutputStreamWriter(process.outputStream))
         ).init()
      }
  }
}

data class IdeResponse<A>(
  val command: String,
  val args: List<String>,
  val result: A
) {
  companion object {

    val fromJsonOfBrowseItems = fromJsonWith(gson.fromJsonArrayWith(BrowseItem.fromJsonElement))
    val fromJsonOfString = fromJsonWith { e -> Either.catchNonFatal { e.asString } }

    private fun <A> fromJsonWith(
      f: (JsonElement) -> Either<Throwable, A>
    ): (String) -> Either<Throwable, IdeResponse<A>> = { s ->
      Either.catchNonFatal {
        JsonParser().parse(s).asJsonObject
      }.leftMap { e ->
        IllegalStateException("Failed to parse JSON: $s", e) as Throwable
      }.flatMap { o ->
        f(o.get("result")).map { result ->
          IdeResponse(
            o.get("command").asString,
            o.get("args").asJsonArray.toList().map { it.asString },
            result
          )
        }
      }
    }
  }
}

data class IdeError(
  val message: String
) {
  companion object {
    val fromJson = gson.fromJson(IdeError::class.java)
    val fromJsonElement = gson.fromJsonElement(IdeError::class.java)
  }
}

data class BrowseItem(
  val name: String,
  val isOp: Boolean,
  val type: String?
) {
  companion object {
    val fromJson = gson.fromJson(BrowseItem::class.java)
    val fromJsonElement = gson.fromJsonElement(BrowseItem::class.java)
  }
}

object gson {

  val gson = Gson()

  fun <A> fromJson(cls: Class<A>): (String) -> Either<Throwable, A> =
    { s -> Either.catchNonFatal { gson.fromJson(s, cls) } }

  fun <A> fromJsonElement(cls: Class<A>): (JsonElement) -> Either<Throwable, A> =
    { e -> Either.catchNonFatal { gson.fromJson(e, cls) } }

  fun <A> fromJsonArrayWith(f: (JsonElement) -> Either<Throwable, A>): (JsonElement) -> Either<Throwable, List<A>> =
    { e ->
      Either.catchNonFatal {
        e.asJsonArray.toList().map { x -> f(x).valueOr { throw it } }
      }
    }
}
