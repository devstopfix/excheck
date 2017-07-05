defmodule ExCheck.Error do
  defexception [:message, :counterexample, :result]

  def exception(opts) do
    counterexample = Keyword.fetch!(opts, :counterexample)
    result = Keyword.fetch!(opts, :result)
    %ExCheck.Error{counterexample: counterexample, result: result}
  end

  def message(%{result: result, counterexample: counterexample}) do
    """
    Property check error

    Test resulted with:

      #{inspect result}
    """
  end
end
