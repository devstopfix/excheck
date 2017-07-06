defmodule ExCheck.Formatter.CLI do
  import ExUnit.Formatter, only: [format_time: 2, format_filters: 2, format_test_failure: 5,
                                  format_test_case_failure: 5]

  def failure(test, error, [{:error, error, _}] = failures, _, config) do
    formatted = [
      format_test_failure(test, failures, config.failure_counter + 1,
                          config.width, &formatter(&1, &2, config)),
      format_counterexample(error, config)
    ]

    print_failure(formatted, config)
    print_logs(test.logs)
  end

  def summary(config) do
    IO.write "\n\n"
    IO.puts formatter(:other, "Finished property tests.", config)
  end

  defp colorize(escape, string, %{colors: colors}) do
    if colors[:enabled] do
      [escape, string, :reset]
      |> IO.ANSI.format_fragment(true)
      |> IO.iodata_to_binary
    else
      string
    end
  end

  defp formatter(:location_info, msg, config),
    do: colorize([:bright, :black], msg, config)

  defp formatter(:error_info, msg, config),
    do: colorize(:red, msg, config)

  defp formatter(:extra_info, msg, config),
    do: colorize(:cyan, msg, config)

  defp formatter(_, msg, _),
    do: msg

  defp print_failure(formatted, config) do
    cond do
      config.trace -> IO.puts ""
      true -> IO.puts "\n"
    end
    IO.puts formatted
  end

  defp format_counterexample(error, config) do
    "\n"
    <> formatter(:extra_info, "     counterexample:\n", config)
    <> formatter(:counterexample, "        #{inspect error.counterexample}", config)
  end

  defp print_logs(""), do: nil

  defp print_logs(output) do
    indent = "\n     "
    output = String.replace(output, "\n", indent)
    IO.puts(["     The following output was logged:", indent | output])
  end
end
