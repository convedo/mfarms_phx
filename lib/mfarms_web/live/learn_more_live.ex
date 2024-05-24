defmodule MfarmsWeb.LearnMoreLive do
  use MfarmsWeb, :live_view
  alias Mfarms.Marketplace

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="py-4 px-8 bg-white rounded shadow-sm">
      <div>
        <h1 class="text-3xl font-bold mb-4">Welcome to the Local Farmers Marketplace!</h1>
        <p class="mb-4">
          Our app connects local West African farmers with larger markets, helping them reach a wider audience and sell their products more efficiently.
        </p>
        <p class="mb-4">
          With our platform, farmers can showcase their produce, set prices, and manage orders. Buyers can browse through a variety of fresh and locally sourced products, place orders, and have them delivered directly to their doorstep.
        </p>
        <p class="mb-4">
          We are committed to supporting local farmers and promoting sustainable agriculture practices. By connecting farmers with larger markets, we aim to improve their livelihoods and contribute to the economic growth of the region.
        </p>
        <p>
          Join us in empowering local farmers and enjoy the benefits of fresh, high-quality produce!
        </p>
      </div>
    </div>
    """
  end
end
