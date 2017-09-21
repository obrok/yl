defmodule YlParserTest do
  use ExUnit.Case, async: true

  test "application vs. application precedence" do
    assert {:ok, {:module, _, [
      {:declaration, {:lower_identifier, _, :x}, [],
        {:call, {:call, {:lower_identifier, _, :foo}, []}, _}}]}} =
    :yl_compiler.parse("""
      module Test where

      x = foo bar baz;
    """)
  end

  test "operator vs. function application precedence" do
    assert {:ok, {:module, _, [
      {:declaration, {:lower_identifier, _, :x}, [],
        {{:+, _}, {:call, {:call, {:lower_identifier, _, :foo}, _}, _}, {:call, _, _}}}]}} =
    :yl_compiler.parse("""
      module Test where

      x = foo bar + bar foo;
    """)
  end
end
