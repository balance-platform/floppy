defmodule Floppy do
  @moduledoc """
  Documentation for `Floppy`.
  """

  defmacro json_assert(result, options \\ []) do
    name = get_name(binding())

    quote do
      require Floppy.Check
      path = Floppy.path_for(__ENV__, unquote(name), ".json")
      result = Jason.encode!(unquote(result), pretty: true)
      Floppy.Check.check(path, result, &Jason.decode!/1)
    end
  end

  defmacro json_plain_assert(result, options \\ []) do
    name = get_name(binding())

    quote do
      require Floppy.Check
      path = Floppy.path_for(__ENV__, unquote(name), ".json")
      result = Jason.encode!(unquote(result), pretty: false)
      Floppy.Check.check(path, result, &Jason.decode!/1)
    end
  end

  defmacro assert(result, options \\ []) do
    name = get_name(binding())

    quote do
      require Floppy.Check
      path = Floppy.path_for(__ENV__, unquote(name), ".floppy")
      result = :erlang.term_to_binary(unquote(result))
      Floppy.Check.check(path, result, &:erlang.binary_to_term/1)
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
