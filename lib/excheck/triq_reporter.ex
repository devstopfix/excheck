defmodule ExCheck.TriqReporter do
  alias ExCheck.Counter

  def report(:success, count), do: Counter.register_success(count)
  def report(:check_failed, [_count, _error]), do: nil
  def report(:counterexample, _counter_example), do: nil
  def report(:skip, _), do: nil
  def report(:testing, [_module, _fun]), do: nil
  def report(:fail, false), do: nil
  def report(:fail, _value), do: nil
  def report(:pass, _), do: nil
end

