defmodule YlTest do
  use ExUnit.Case, async: false

  test "a basic module" do
    code = """
      module #{module_name()} where

      x = 2
    """

    {:ok, mod} = :yl_compiler.compile(code)
    assert 2 = mod.x
  end

  defp module_name(), do: "Basic#{:erlang.unique_integer([:positive, :monotonic])}"
end
