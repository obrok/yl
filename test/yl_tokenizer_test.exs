defmodule YlTokenizerTest do
  use ExUnit.Case, async: true

  test "ignoring tabs" do
    assert {:ok, [_, _], _} = tokenize("token\ttoken")
  end

  test "tokenizing a simple string" do
    {:ok, [{:string, _, result}], _} = tokenize(~S["Hello world"])
    assert "Hello world" = to_string(result)
  end

  test "tokenizing a string with escaped quotes" do
    {:ok, [{:string, _, result}], _} = tokenize(~S["\"Hello \" world\""])
    assert ~S["Hello " world"] = to_string(result)
  end

  test "tokenizing a string with escaped backslashes" do
    {:ok, [{:string, _, result}], _} = tokenize(~S["\\Hello \\ world\\"])
    assert "\\Hello \\ world\\" = to_string(result)
  end

  def tokenize(binary) do
    binary |> to_charlist() |> :yl_tokenizer.string()
  end
end
