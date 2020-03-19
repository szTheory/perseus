require Logger

defmodule Stts do
  defstruct(
    name: :stts,
    entry_count: 0,
    sample_count: [],
    sample_delta: []
  )

  defmodule Loop do
    def loop(<<sc::integer-32, sd::integer-32, rest::binary>>, sc_l, sd_l) do
      loop(rest, sc_l ++ [sc], sd_l ++ [sd])
    end

    def loop(<<>>, sc_l, sd_l) do
      {sc_l, sd_l}
    end
  end
end

defimpl Box, for: Stts do
  def parse(_, file, size) do
    <<
      _version::integer-32,
      entry_count::integer-32,
      rest::binary
    >> = IO.binread(file, size)

    {sc_l, sd_l} =
      Enum.reduce(
        Enum.zip(
          Stream.cycle([1, 2]),
          for <<i::integer-32 <- rest>> do
            i
          end
        ),
        {[], []},
        fn x, {a, b} ->
          case elem(x, 0) do
            1 -> {a ++ [elem(x, 1)], b}
            2 -> {a, b ++ [elem(x, 1)]}
          end
        end
      )

    %Stts{
      entry_count: entry_count,
      sample_count: sc_l,
      sample_delta: sd_l
    }
  end
end
