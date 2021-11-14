# Floppy

Library, that dumps your test to files on first run.

On second run test's result are compared with dumps.

# Where is it needed?

For example, if you have many tests, which are checking function result, API for example. You can use Floppy

# Usage example

```elixir

test "Returns list of Items in the Cart" do
  cart = Cart.find_by(email: "some.richman@microsoft.com)
  items = CartItems.find_by(cart: cart)

  Floppy.assert(items)
end

```

`Floppy.assert` on first run generates file with extension `.floppy`, but on second run `items` are compared with previous result.

If results are equal, test passed. Otherwise you have to change test or accept new result by command `FLOPPY_MODE=rewrite mix test path_to_failed_test.exs`


## Installation


```elixir
def deps do
  [
    {:floppy, "~> 0.1.0"}
  ]
end
```


