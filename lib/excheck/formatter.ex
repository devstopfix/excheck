defmodule ExCheck.Formatter do
  @version140_or_later Version.compare(System.version, "1.4.0") in [:gt, :eq]

  import ExUnit.Formatter, only: [format_time: 2, format_filters: 2, format_test_failure: 5,
                                  format_test_case_failure: 5]

  if @version140_or_later do
    use GenServer
  else
    use GenEvent
  end

  alias ExUnit.CLIFormatter, as: CF

  @moduledoc """
  Helper module for properly formatting test output.

  This formatter implements a GenEvent based ExUnit formatter when an Elixir version prior to 1.4.0
  is used, and otherwise implements a GenServer based formatter.
  """

  @doc false
  def init(opts) do
    CF.init(opts)
  end

  def handle_cast({:test_finished, %{state: {:failed, [{:error, %ExCheck.Error{} = error, _}] = failures}} = test}, config) do
    formatted = [
      format_test_failure(test, failures, config.failure_counter + 1,
                          config.width, &formatter(&1, &2, config)),
      format_counterexample(error, config)
    ]

    print_failure(formatted, config)
    print_logs(test.logs)

    {:noreply, %{config | test_counter: update_test_counter(config.test_counter, test),
                          failure_counter: config.failure_counter + 1}}
  end
  def handle_cast({:suite_finished, run_us, load_us} = event, config) do
    print_summary(config)
    CF.handle_cast(event, config)
  end
  defdelegate handle_cast(event, config), to: CF

  def print_summary(config) do
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

  defp formatter(level,  msg, _config),
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

  defp update_test_counter(test_counter, %{tags: %{type: type}}) do
    Map.update(test_counter, type, 1, &(&1 + 1))
  end
end
