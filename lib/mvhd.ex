defmodule Mvhd do
  defstruct data: nil
end

defimpl Box, for: Mvhd do
  def parse(_, file, size) do
    :file.position(file, {:cur, size - 8})
    %Mvhd{}
  end
end
