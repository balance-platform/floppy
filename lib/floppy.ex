defmodule Floppy do
  @moduledoc """
  Documentation for `Floppy`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Floppy.hello()
      :world

  """
  def hello do
    :world
  end

  defmacro floppy_assert(result) do
    quote do
      env = __ENV__

      dir = String.replace(env.file, ".exs", "")

      {file, _} = env.function

      path = dir <> "/" <> to_string(file) <> ".floppy"

      result = inspect(unquote(result), pretty: true, limit: :infinity)

      if !File.exists?(path) || System.get_env("FLOPPY") == "REWRITE" do
        File.mkdir_p!(dir)

        File.write!(dir <> "/" <> to_string(file) <> ".floppy", result)

        assert true
      else
        previous_result = File.read!(path)

        assert previous_result == result
      end
    end
  end
end
