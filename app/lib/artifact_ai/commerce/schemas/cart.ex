defmodule ArtifactAi.Commerce.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  alias ArtifactAi.Accounts.User
  alias ArtifactAi.Commerce.Order
  alias ArtifactAi.Commerce.CartItem

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "carts" do
    belongs_to :user, User, type: Ecto.UUID

    has_one :order, Order
    has_many :items, CartItem

    timestamps()
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [])
    |> validate_required([])
  end
end
