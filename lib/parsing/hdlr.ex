defmodule Hdlr do
  defstruct(
    name: :hdlr,
    predefined: 0,
    handler_type: <<>>,
    reserved: [],
    handler_name: <<>>
  )
end

defimpl Box, for: Hdlr do
  def parse(_, file, size) do
    <<
      _::binary-size(4),
      predefined::integer-32,
      rest::binary
    >> = IO.binread(file, size)

    <<
      a::integer-8,
      b::integer-8,
      c::integer-8,
      d::integer-8,
      rest::binary
    >> = rest

    <<
      reserved1::integer-32,
      reserved2::integer-32,
      reserved3::integer-32,
      rest::binary
    >> = rest

    %Hdlr{
      predefined: predefined,
      handler_type: <<a, b, c, d>>,
      reserved: [reserved1, reserved2, reserved3],
      handler_name: binary_part(rest, 0, byte_size(rest) - 1)
    }
  end
end