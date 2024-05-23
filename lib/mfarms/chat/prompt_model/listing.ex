defmodule Mfarms.Chat.PromptModel.Listing do
  use Ecto.Schema
  use Instructor.Validator

  @doc """
  A listing is a product that is being sold.

  ## Fields
  - name: The name of the product or produce being sold extracted from the chat. If not found leave the value empty
  - price: A float that contains the price of the product extracted from the chat. If not found leave the value empty
  - currency: A string that contains the currency of the price of the product extracted from the chat. If not found leave the value empty
  - quantity: An integer that contains the quantity of the product extracted from the chat. If not found leave the value empty
  - unit: Optional string that contains the unit of the product extracted from the chat. Only needed if product is not sold in pieces. If not found leave the value empty
  """

  @primary_key false
  embedded_schema do
    field(:name, :string)
    field(:price, :float)
    field(:currency, :string)
    field(:quantity, :integer)
    field(:unit, :string)
  end

  @impl true
  def validate_changeset(changeset) do
    changeset
    |> Ecto.Changeset.validate_required([:name, :price, :currency, :quantity])
  end
end
