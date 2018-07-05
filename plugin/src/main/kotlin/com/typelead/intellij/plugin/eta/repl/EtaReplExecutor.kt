package com.typelead.intellij.plugin.eta.repl

import com.intellij.execution.configurations.GeneralCommandLine
import com.typelead.intellij.utils.Either
import com.typelead.intellij.utils.NonEmptyList
import com.typelead.intellij.utils.SystemUtil
import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.util.*
import java.util.regex.Pattern

data class EtaReplSettings(
  val workDir: String,
  val etaReplCommand: NonEmptyList<String>,
  val etaReplArgs: List<String>
)

class EtaReplExecutor(settings: EtaReplSettings) {

  private var process: EtaReplProcess? = null

  fun exec(command: String): Either<Throwable, String> =
    TODO()
}

class EtaReplProcess private constructor(
  private val process: Process,
  private val input: BufferedReader,
  private val output: BufferedWriter
) {

  private var version: String? = null

  private val prompt = "intellij-eta-repl-${UUID.randomUUID()}>"

  fun interact(command: String): Either<Throwable, String> =
    write(command).then { read(checkPrompt = true) }

  fun kill(): Either<Throwable, Unit> =
    Either.catchNonFatal { process.destroy() }
      .then { Either.catchNonFatal { input.close() } }
      .then { Either.catchNonFatal { output.close() } }

  /** Initialize the repl, consuming until the first prompt. */
  private fun init(): Either<Throwable, EtaReplProcess> =
    write(":set +c").then {
      // Use a trailing \n so that `input.readLine()` in `read()` will contain just prompt
      // so we can use it as a delimiter.
      write(""":set prompt "$prompt\n" """)
    }.then {
      // Consume output until the prompt.
      read(checkPrompt = true).bimap<Throwable, EtaReplProcess>(
        { e -> ReplError.InitError("Failed to read output to prompt", e) },
        { s ->
          detectVersion(s).map { v -> this.version = v }
          this
        }
      )
    }

  private fun detectVersion(out: String): Optional<String> {
    val m = STARTUP_VERSION_REGEX.matcher(out)
    if (!m.find()) return Optional.empty()
    val version = m.group(1)
    // Convert a version number of 0.
    return Optional.of(version.replace('b', '.'))
  }

  private fun write(command: String): Either<Throwable, Unit> =
    Either.catchNonFatal {
      output.write(command)
      output.newLine()
      output.flush()
    }.leftMap { e ->
      val message = read(checkPrompt = false).toOptional().filter { it.trim().isNotEmpty() }.orElse(e.toString())
      ReplError.ExecError(command, message, e)
    }

  private fun read(checkPrompt: Boolean): Either<Throwable, String> =
    Either.catchNonFatal {
      val builder = StringBuilder()
      while (true) {
        val line: String? = input.readLine()
        if (line == prompt) break
        if (line == null) {
          if (checkPrompt) throw IllegalStateException("Could not find prompt from output: ${builder.toString()}")
          break
        }
        builder.append(line).append(SystemUtil.LINE_SEPARATOR)
      }
      builder.toString()
    }

  companion object {

    sealed class ReplError(message: String, cause: Throwable?) : Exception(message, cause) {

      class InitError(message: String, cause: Throwable?)
        : ReplError("Failed to initialize repl: $message", cause)

      class ExecError(command: String, message: String, cause: Throwable?)
        : ReplError("Executing repl command '$command' failed: $message", cause)
    }

    fun spawn(settings: EtaReplSettings): Either<Throwable, EtaReplProcess> =
      execNumericVersion(settings).flatMap { version ->
       Either.catchNonFatal {
          GeneralCommandLine()
            .withExePath(settings.etaReplCommand.head)
            .withParameters(settings.etaReplCommand.tail + settings.etaReplArgs)
            .withWorkDirectory(settings.workDir)
            .withRedirectErrorStream(true)
            .createProcess()
        }.map { process ->
          EtaReplProcess(
            process = process,
            input   = BufferedReader(InputStreamReader(process.inputStream)),
            output  = BufferedWriter(OutputStreamWriter(process.outputStream))
          )
        }.flatMap {
         it.init()
       }.flatMap { p ->
         // init() attempts to set the version field. If this fails it will be null and
         // we can fall back to shelling out to obtain the version info.
         if (p.version == null) execNumericVersion(settings).map { v -> p.version = v; p }
         else Either.right<Throwable, EtaReplProcess>(p)
       }
      }

    private val STARTUP_VERSION_REGEX = Pattern.compile("Welcome to Eta REPL v([0-9.b])")

    private fun execNumericVersion(settings: EtaReplSettings): Either<Throwable, String> =
      Either.catchNonFatal {
        GeneralCommandLine()
          .withExePath(settings.etaReplCommand.head)
          .withParameters(getNumericVersionParameters(settings))
          .withWorkDirectory(settings.workDir)
          .createProcess()
      }.flatMap { process ->
        Either.catchNonFatal { process.inputStream.bufferedReader().readLine() }
      }

    private fun getNumericVersionParameters(settings: EtaReplSettings): List<String> =
      if (settings.etaReplCommand.head == "etlas") {
        settings.etaReplCommand.tail + "--eta-option=--numeric-version"
      } else {
        throw IllegalArgumentException("Unknown eta-repl command type: ${settings.etaReplCommand.head}")
      }
  }
}
