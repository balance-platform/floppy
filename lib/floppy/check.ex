defmodule Floppy.Check do
  defmacro check(path, result, decode_fun) do
    quote bind_quoted: [path: path, result: result, decode_fun: decode_fun] do
      rewrite = System.get_env("FLOPPY_MODE") == "rewrite"

      if File.exists?(path) do
        previous_result = File.read!(path)
        are_same = decode_fun.(previous_result) == decode_fun.(result)

        if rewrite && !are_same do
          File.write!(path, result)
          assert true
        else
          assert are_same
        end
      else
        File.mkdir_p!(Path.dirname(path))
        File.write!(path, result)
        assert true
      end
    end
  end
end
