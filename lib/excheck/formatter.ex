defmodule ExCheck.Formatter do
  @moduledoc """
  Helper module for properly formatting test output.
  This formatter implements a GenEvent based ExUnit formatter when an Elixir version prior to 1.4.0
  is used, and otherwise implements a GenServer based formatter.
  """

  use GenServer

  alias ExUnit.CLIFormatter, as: CF

  @doc false
  def init(opts) do
    CF.init(opts)
  end

  @doc false
  def handle_cast(event = {:suite_finished, _run_us, _load_us}, config) do
    updated_tests_count = update_tests_counter(config.test_counter)
    new_cfg = %{config | test_counter: updated_tests_count}
    CF.handle_cast(event, new_cfg)
  end

  def handle_cast(event, config) do
    CF.handle_cast(event, config)
  end

  defp update_tests_counter(tests_counter) when is_integer(tests_counter) do
    tests_counter + ExCheck.TriqAgent.get_tests_count()
  end

  defp update_tests_counter(%{test: _} = tests_counter) when is_map(tests_counter) do
    %{tests_counter | test: tests_counter.test + ExCheck.TriqAgent.get_tests_count()}
  end

  defp update_tests_counter(m) when is_map(m), do: m
end
