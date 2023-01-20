defmodule Floppy.Check do
  defmacro check(path, result, decode_fun) do
    quote bind_quoted: [path: path, result: result, decode_fun: decode_fun] do
      if !File.exists?(path) || System.get_env("FLOPPY_MODE") == "rewrite" do
        File.mkdir_p!(Path.dirname(path))
        File.write!(path, result)

        assert true
      else
        previous_result = File.read!(path)

        assert decode_fun.(previous_result) == decode_fun.(result)
      end
    end
  end
end
