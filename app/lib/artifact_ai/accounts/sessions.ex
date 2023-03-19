defmodule ArtifactAi.Sessions do
  @moduledoc false
  alias ArtifactAi.Repo
  import Ecto.Query

  alias ArtifactAi.Accounts.Session

  def create_session_token(account) do
    token = Session.build_session_token(account)
    Repo.insert!(token)
    token.token
  end

  def delete_session_token(token) do
    query = from s in Session, where: s.token == ^token
    Repo.delete_all(query)
    :ok
  end
end
