defmodule ExCheck.Formatter do
  @version140_or_later Version.compare(System.version, "1.4.0") in [:gt, :eq]

  alias ExCheck.Formatter.CLI

  if @version140_or_later do
    use GenServer
  else
    use GenEvent
  end

  alias ExUnit.CLIFormatter, as: CF
  alias ExCheck.Counter

  @moduledoc """
  Helper module for properly formatting test output.

  This formatter implements a GenEvent based ExUnit formatter when an Elixir version prior to 1.4.0
  is used, and otherwise implements a GenServer based formatter.
  """

  defdelegate init(opts), to: CF

  def handle_cast({:test_finished, %{state: nil, tags: %{excheck: true}}} = event, config) do
    count = Counter.get_and_reset()
    return_config =
      Enum.reduce(1..count, config, fn
        (_, acc_config) ->
          {:noreply, new_config} = CF.handle_cast(event, acc_config)
          new_config
      end)
    {:noreply, return_config}
  end
  def handle_cast({:test_finished, %{state: {:failed, [_] = failures, _}] = failures}, %{excheck: true}} = test}, config) do
    {:noreply, test_failed(test, failures, config)}
  end
  def handle_cast({:suite_finished, _run_us, _load_us} = event, config) do
    CLI.summary(config)
    CF.handle_cast(event, config)
  end
  defdelegate handle_cast(event, config), to: CF

  defp test_failed(test, error, failures, config) do
    CLI.failure(test, error, failures, config)
    %{config | test_counter: update_test_counter(config.test_counter, test),
      failure_counter: config.failure_counter + 1}
  end

  defp update_test_counter(test_counter, %{tags: %{type: type}}) do
    inc = Counter.get_and_reset()

    Map.update(test_counter, type, inc, &(&1 + inc))
  end
end
