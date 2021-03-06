defmodule YlTest do
  use ExUnit.Case, async: true

  test "a basic module" do
    {:ok, mod} = :yl_compiler.compile("""
      module #{module_name()} where

      x = 2 + 3 * 10;
      y = 2;
    """)

    assert 32 = mod.x()
    assert 2 = mod.y()
  end

  test "referencing declarations" do
    {:ok, mod} = :yl_compiler.compile("""
      module #{module_name()} where

      x = y * y;
      y = 2;
    """)

    assert 4 = mod.x()
  end

  test "calling functions" do
    {:ok, mod} = :yl_compiler.compile("""
      module #{module_name()} where

      x = y 2 (2 * 3);
      y a b = a + 2 * b;
    """)

    assert 14 = mod.x()
  end

  test "constructing pairs" do
    {:ok, mod} = :yl_compiler.compile("""
      module #{module_name()} where

      x = {1 + 3, 2 + 6};
    """)

    assert {4, 8} = mod.x()
  end

  test "partial application" do
    {:ok, mod} = :yl_compiler.compile("""
      module #{module_name()} where

      x = (y 2) 3;
      y a b = a + b;
    """)

    assert 5 = mod.x()
  end

  test "strings" do
    {:ok, mod} = :yl_compiler.compile("""
      module #{module_name()} where

      x = "Hello World";
    """)

    assert "Hello World" = mod.x()
  end

  defp module_name(), do: "Basic#{:erlang.unique_integer([:positive, :monotonic])}"
end
