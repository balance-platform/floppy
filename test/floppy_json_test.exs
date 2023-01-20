defmodule FloppyJsonTest do
  use ExUnit.Case
  require Floppy

  test "map saves with pretty format" do
    map =
      0..1024
      |> Enum.to_list()
      |> Enum.map(fn i -> {i, i * 2} end)
      |> Map.new()

    Floppy.json_assert(map)
  end

  test "list check" do
    list_1024 =
      0..1024
      |> Enum.to_list()

    Floppy.json_assert(list_1024)
    Floppy.json_assert([])
  end

  test "json_plain_assert" do
    list_1024 =
      0..1024
      |> Enum.to_list()

    Floppy.json_plain_assert(list_1024)
    Floppy.json_plain_assert([])
  end
end
