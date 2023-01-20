defmodule Floppy do
  @moduledoc """
  Documentation for `Floppy`.
  """

  defmacro json_assert(result, options \\ []) do
    name = get_name(binding())

    quote do
      path = Floppy.path_for(__ENV__, unquote(name), ".json")
      dir = Path.dirname(path)
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
      path = Floppy.path_for(__ENV__, unquote(name), ".floppy")
      dir = Path.dirname(path)
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

  def path_for(env, varname, ext) do
    dir = String.replace(env.file, ".exs", "")
    {file, _} = env.function

    (dir <> "/" <> to_string(file) <> inspect(varname) <> ext)
    |> String.replace([" ", "\""], "_")
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
