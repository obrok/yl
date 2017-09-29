defmodule YlTokenizerTest do
  use ExUnit.Case, async: true

  test "ignoring tabs"

  test "tokenizing a simple string" do
    assert {:ok, [{:string, _, "Hello world"}], _} = tokenize(~S["Hello world"])
  end

  test "tokenizing a string with escaped quotes" do
    assert {:ok, [{:string, _, ~S["Hello " world"]}], _} = tokenize(~S["\"Hello \" world\""])
  end

  test "tokenizing a string with escaped backslashes" do
    assert {:ok, [{:string, _, "\\Hello \\ world\\"}], _} = tokenize(~S["\\Hello \\ world\\"])
  end

  def tokenize(binary) do
    binary |> to_charlist() |> :yl_tokenizer.string()
  end
end
