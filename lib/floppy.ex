defmodule Floppy do
  @moduledoc """
  Documentation for `Floppy`.
  """

  defmacro json_assert(result, options \\ []) do
    name = get_name(binding())

    quote do
      env = __ENV__

      dir = String.replace(env.file, ".exs", "")

      {file, _} = env.function
      name = unquote(name)

      path =
        (dir <> "/" <> to_string(file) <> inspect(unquote(name)) <> ".json")
        |> String.replace(["\""], "")
        |> String.replace([" "], "_")

      result = Jason.encode!(unquote(result), pretty: true)

      if !File.exists?(path) || System.get_env("FLOPPY_MODE") == "rewrite" do
        File.mkdir_p!(dir)

        File.write!(path, result)

        assert true
      else
        previous_result = File.read!(path)

        assert Jason.decode!(previous_result) == Jason.decode!(result)
      end
    end
  end

  defmacro assert(result, options \\ []) do
    name = get_name(binding())

    quote do
      env = __ENV__

      dir = String.replace(env.file, ".exs", "")

      {file, _} = env.function
      name = unquote(name)

      path =
        (dir <> "/" <> to_string(file) <> inspect(unquote(name)) <> ".floppy")
        |> String.replace([" ", "\""], "_")

      result = unquote(result)

      if !File.exists?(path) || System.get_env("FLOPPY_MODE") == "rewrite" do
        File.mkdir_p!(dir)

        File.write!(path, :erlang.term_to_binary(result))

        assert true
      else
        previous_result = File.read!(path)

        assert :erlang.binary_to_term(previous_result) == result
      end
    end
  end

  defp get_name(bindings) do
    name =
      case Keyword.get(bindings, :result) do
        nil -> "nil"
        {name, _line, _value} -> name
        value -> value
      end

    name
    |> to_string()
    |> String.replace(":", "_")
  end
end
