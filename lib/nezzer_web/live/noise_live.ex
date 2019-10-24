defmodule NezzerWeb.NoiseLive do
  use Phoenix.LiveView

  @frame_time 16
  @resolution {50, 20}

  defmacro pixel_divs() do
    @resolution
    |> elem(1)
    |> (&Range.new(0, &1)).()
    |> Enum.map(&"<div class=\"pixel\" style=\"background: <%= @c#{&1} %>\"></div>")
    |> Enum.join("")
    |> (&"<div class=\"screen\">#{&1}</div>").()
    |> EEx.compile_string(engine: Phoenix.LiveView.Engine)
  end


  def render(assigns) do
    # """
    # <div class="screen">
    #   <div class="pixel" style="background: <%= @c0 %>"></div>
    #   <div class="pixel" style="background: <%= @c1 %>"></div>
    #   <div class="pixel" style="background: <%= @c2 %>"></div>
    #   <div class="pixel" style="background: <%= @c3 %>"></div>
    #   <div class="pixel" style="background: <%= @c4 %>"></div>
    #   <div class="pixel" style="background: <%= @c5 %>"></div>
    #   <div class="pixel" style="background: <%= @c6 %>"></div>
    #   <div class="pixel" style="background: <%= @c7 %>"></div>
    #   <div class="pixel" style="background: <%= @c8 %>"></div>
    #   <div class="pixel" style="background: <%= @c9 %>"></div>
    #   <div class="pixel" style="background: <%= @c10 %>"></div>
    #   <div class="pixel" style="background: <%= @c11 %>"></div>
    #   <div class="pixel" style="background: <%= @c12 %>"></div>
    #   <div class="pixel" style="background: <%= @c13 %>"></div>
    #   <div class="pixel" style="background: <%= @c14 %>"></div>
    #   <div class="pixel" style="background: <%= @c15 %>"></div>
    #   <div class="pixel" style="background: <%= @c16 %>"></div>
    #   <div class="pixel" style="background: <%= @c17 %>"></div>
    #   <div class="pixel" style="background: <%= @c18 %>"></div>
    #   <div class="pixel" style="background: <%= @c19 %>"></div>
    #   <div class="pixel" style="background: <%= @c20 %>"></div>
    # </div>
    # """

    pixel_divs()
  end

  def mount(_session, socket) do
    {_, height} = @resolution
    cells = 0..height |> Map.new(fn n -> {n, "black"} end) |> Map.put(2, "lime")

    new_socket = socket |> assign(:cells, cells) |> explode_cells()

    Process.send_after(self(), :tick, @frame_time)

    {:ok, new_socket}
  end

  def handle_info(:tick, socket) do
    new_cells = shift(socket.assigns.cells)
    new_socket = socket |> assign(:cells, new_cells) |> explode_cells()

    Process.send_after(self(), :tick, @frame_time)

    {:noreply, new_socket}
  end

  def shift(cells) do
    count = cells |> Map.to_list() |> length()
    Map.new(cells, fn {i, _} -> {i, Map.get(cells, rem(i + 1, count))} end)
  end

  def explode_cells(socket) do
    socket.assigns.cells
    # |> Enum.map(fn {k, v} -> {Integer.to_string(k), v} end)
    |> Enum.reduce(socket, fn {k, v}, s -> assign(s, :"c#{k}", v) end)
  end
end
