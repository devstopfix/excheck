defmodule ExCheck.Counter do
  defstruct counter: 0

  alias __MODULE__

  def start_link do
    Agent.start_link fn -> %Counter{} end, name: __MODULE__
  end

  def register_success(count) do
    Agent.update(__MODULE__, fn(%{counter: c} = state) ->
      %{state | counter: c + count}
    end)
  end

  def get_and_reset() do
    Agent.get_and_update(__MODULE__, fn(%{counter: c} = state) ->
      {c, %{state | counter: 0}}
    end)
  end
end
