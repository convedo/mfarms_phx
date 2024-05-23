defmodule Mfarms.Chat.PromptModel.Farmer do
  use Ecto.Schema
  use Instructor.Validator

  @doc """
  A farmer is a user that is selling products.
  ## Fields
  - first_name: A string that contains the first name of the farmer provided by the user and extracted from the message - otherwise leave null
  - last_name: A string that contains the last name of the farmer provided by the user and extracted from the message - otherwise leave null
  - phone_number: A string that contains the phone number of the farmer provided by the user and extracted from the message - otherwise leave null
  - location: A string that contains the location of the farmer provided by the user and extracted from the message - otherwise leave null
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
