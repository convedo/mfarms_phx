defmodule Mfarms.Chat.PromptModel.Intention do
  use Ecto.Schema
  use Instructor.Validator

  @doc """
  An intention is a user's intention to start a new conversation or continue an existing one.
    - topic: The topic of the conversation
      - place_listing: The user wants to place a listing
      - weather: The user wants to know the weather forecase
      - view_marketprices: The user wants to view market prices
      - unkown: The user's intention is unkown
    - new_conversation: A boolean that indicates if the user wants to start a new conversation. Meaning that the user has changed the topic of the conversation
  """

  @primary_key false
  embedded_schema do
    field :topic, Ecto.Enum, values: [:place_listing, :weather, :view_marketprices, :unkown]
    field :new_conversation, :boolean
  end
end
