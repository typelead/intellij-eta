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
  private val version: String,
  private val process: Process,
  private val input: BufferedReader,
  private val output: BufferedWriter
) {

  private val prompt = "intellij-eta-repl-${UUID.randomUUID()}>"

  fun interact(command: String): Either<Throwable, String> =
    write(command).then { read(checkPrompt = true) }

  private fun write(command: String): Either<Throwable, Unit> =
    Either.catchNonFatal {
      output.write(command)
      output.newLine()
      output.flush()
    }.leftMap { e ->
      val message = read(checkPrompt = false).toOptional().filter { it.trim().isNotEmpty() }.orElse(e.toString())
      ExecError(command, message, e)
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

    class InitError(message: String, cause: Throwable?)
      : Exception("Failed to initialize repl: $message", cause)

    class ExecError(command: String, message: String, cause: Throwable?)
      : Exception("Executing repl command '$command' failed: $message", cause)

    fun spawn(settings: EtaReplSettings): Either<Throwable, EtaReplProcess> =
      getVersion(settings).flatMap { version ->
       Either.catchNonFatal {
          GeneralCommandLine()
            .withExePath(settings.etaReplCommand.head)
            .withParameters(settings.etaReplCommand.tail + settings.etaReplArgs)
            .withWorkDirectory(settings.workDir)
            .withRedirectErrorStream(true)
            .createProcess()
        }.map { process ->
          EtaReplProcess(
            version = version,
            process = process,
            input   = BufferedReader(InputStreamReader(process.inputStream)),
            output  = BufferedWriter(OutputStreamWriter(process.outputStream))
          )
        }.flatMap { p ->
           p.write(":set +c").then {
             // Use a trailing \n so that `input.readLine()` in `read()` will contain just prompt
             // so we can use it as a delimiter.
             p.write(""":set prompt "${p.prompt}\n" """)
           }.then {
             p.read()
           }.flatMap { s ->
             Either.cond<Throwable, EtaReplProcess>(
               s.endsWith(p.prompt),
               { p },
               { InitError("Could not find prompt '${p.prompt}' in repl output:\n$s", cause = null) }
             )
           }
        }
      }

    private fun getVersion(settings: EtaReplSettings): Either<Throwable, String> =
      Either.catchNonFatal {
        GeneralCommandLine()
          .withExePath(settings.etaReplCommand.head)
          .withParameters(getVersionParams(settings))
          .withWorkDirectory(settings.workDir)
          .createProcess()
      }.flatMap { process ->
        Either.catchNonFatal { process.inputStream.bufferedReader().readLine() }
      }

    private fun getVersionParams(settings: EtaReplSettings): List<String> =
      if (settings.etaReplCommand.head == "etlas") {
        settings.etaReplCommand.tail + "--eta-option=--numeric-version"
      } else {
        throw IllegalArgumentException("Unknown eta-repl command type: ${settings.etaReplCommand.head}")
      }
  }
}
