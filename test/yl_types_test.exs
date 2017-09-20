defmodule YlTypesTest do
  use ExUnit.Case, async: true

  test "defining types" do
    assert {:ok, _} = :yl_compiler.compile("""
      module #{module_name()} where

      type A = Integer;
      type B = A | C;
      type C = {Integer, Integer};
    """)
  end

  defp module_name(), do: "Types#{:erlang.unique_integer([:positive, :monotonic])}"
end
