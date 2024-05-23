defmodule Mfarms.Chat.PromptModel.Farmer do
  use Ecto.Schema
  use Instructor.Validator

  @doc """
  A farmer is a user that is selling products.
  ## Fields
  - first_name: First name of the farmer extracted from the chat. If not found leave the value empty
  - last_name: Last name of the farmer extracted from the chat. If not found leave the value empty
  - phone_number: Phone number of the farmer extracted from the chat. If not found leave the value empty
  - location: Location of the farmer extracted from the chat. If not found leave the value empty
  """
  @primary_key false
  embedded_schema do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:phone_number, :string)
    field(:location, :string)
  end

  @impl true
  def validate_changeset(changeset) do
    changeset
    |> Ecto.Changeset.validate_required([:first_name, :last_name, :phone_number, :location])
  end
end
