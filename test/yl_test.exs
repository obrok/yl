defmodule YlTest do
  use ExUnit.Case, async: false

  test "a basic module" do
    code = """
      module #{module_name()} where

      x = 2 + 3 * 10
    """

    {:ok, mod} = :yl_compiler.compile(code)
    assert 32 = mod.x
  end

  defp module_name(), do: "Basic#{:erlang.unique_integer([:positive, :monotonic])}"
end
