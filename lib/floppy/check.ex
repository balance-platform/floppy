defmodule Floppy.Check do
  defmacro check(path, result, decode_fun) do
    quote do
      path = unquote(path)
      result = unquote(result)
      decode_fun = unquote(decode_fun)
      dir = Path.dirname(path)

      if !File.exists?(path) || System.get_env("FLOPPY_MODE") == "rewrite" do
        File.mkdir_p!(dir)

        File.write!(path, result)

        assert true
      else
        previous_result = File.read!(path)

        assert decode_fun.(previous_result) == decode_fun.(result)
      end
    end
  end
end
