defmodule FloppyTest do
  use ExUnit.Case
  require Floppy

  test "map saves with pretty format" do
    map =
      0..1024
      |> Enum.to_list()
      |> Enum.map(fn i -> {i, i * 2} end)
      |> Map.new()

    Floppy.assert(map)
  end

  test "list check" do
    list =
      0..1024
      |> Enum.to_list()

    Floppy.assert(list)
  end
end
