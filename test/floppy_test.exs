defmodule FloppyTest do
  use ExUnit.Case
  require Floppy

  test "greets the world" do
    Floppy.floppy_assert(Floppy.hello())
  end

  test "map saves with pretty format" do
    map =
      0..1024
      |> Enum.to_list()
      |> Enum.map(fn i -> {i, i * 2} end)
      |> Map.new()

    Floppy.floppy_assert(map)
  end
end
