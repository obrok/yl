defmodule YlTypeCheckerTest do
  use ExUnit.Case, async: true

  test "typechecking simple declarations" do
    assert {:ok, %{x: :Integer, y: {:Integer, :Integer}}} = typecheck("""
      module #{module_name()} where

      x = 2;
      y = {2, 2};
    """)
  end

  test "typechecking succeeds when annotation matches actual type" do
    assert {:ok, %{x: :Integer}} = typecheck("""
      module #{module_name()} where

      x : Integer;
      x = 2;
    """)
  end

  test "typechecking fails when annotation does not match actual type" do
    assert {:error, %{x: {:conflict, [:Integer, {:Integer, :Integer}]}}} = typecheck("""
      module #{module_name()} where

      x : Integer;
      x = {2, 2};
    """)
  end

  defp typecheck(code) do
    {:ok, parsed} = :yl_compiler.parse(code)
    :yl_typechecker.typecheck(parsed)
  end

  defp module_name(), do: "TypeChecker#{:erlang.unique_integer([:positive, :monotonic])}"
end
