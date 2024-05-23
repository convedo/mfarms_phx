defmodule Mfarms.Chat.PromptModel.Listing do
  use Ecto.Schema
  use Instructor.Validator

  @doc """
  A listing is a product that is being sold.

  ## Fields
  - name: A string that contains the name of the listing
  - price: A float that contains the price of the product
  - currency: A string that contains the currency of the price of the product
  - quantity: An integer that contains the quantity of the product
  - unit: Optional string that contains the unit of the product. Only needed if product is not sold in pieces
  """

  @primary_key false
  embedded_schema do
    field(:name, :string)
    field(:price, :float)
    field(:currency, :string)
    field(:quantity, :integer)
    field(:unit, :string)
  end
end
