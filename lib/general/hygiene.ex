defmodule General.Hygiene do
  @moduledoc """
    iex -S mix

    iex(1)> ast = quote do
      if meaning_to_life == 42 do
        IO.puts "It's Correct Bro!!"
      else
        IO.puts "You need to workon!!"
      end
    end
    iex(2)> Code.eval_quoted(ast, meaning_to_life: 42)
    ** (CompileError) nofile:1: undefined function meaning_to_life/0
    (stdlib) lists.erl:1354: :lists.mapfoldl/3
    (elixir) expanding macro: Kernel.if/2
    nofile:1: (file)

    iex(3)> ast = quote do
      if var!(meaning_to_life) == 42 do
        IO.puts "It's Correct Bro!!"
      else
        IO.puts "You need to workon!!"
      end
    end

    iex(4)> Code.eval_quoted(ast, meaning_to_life: 42)
    It's Correct Bro!!
    {:ok, [meaning_to_life: 42]}
  """

  defmacro hygiene do
    quote do: meaning_to_life = 1
  end
end

defmodule General.Hygiene.Test do
  def test_hygiene do
    require General.Hygiene
    # Defined variable in Module_context
    meaning_to_life = 21
    # redefine variable in macro context to 1
    General.Hygiene.hygiene()
    # still pointing to old value i.e. 21
    meaning_to_life
  end
end

# iex -S mix
# iex(1)> General.Hygiene.Test.test_hygiene()
# 21

# To Override
#
defmodule General.HygieneOverload do
  defmacro test_hygiene do
    quote do: var!(meaning_to_life) = 1
  end
end

defmodule General.HygieneOverload.Test do
  def test_hygiene do
    require General.HygieneOverload
    meaning_to_life = 21
    General.HygieneOverload.test_hygiene()
    # will have overloaded value from macro context variable to 1
    meaning_to_life
  end
end

# iex -S mix
# iex(1)> General.HygieneOverload.Test.test_hygiene
# 1
