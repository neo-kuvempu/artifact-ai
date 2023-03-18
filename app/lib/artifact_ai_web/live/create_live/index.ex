defmodule ArtifactAiWeb.CreateLive.Index do
  use ArtifactAiWeb, :live_view

  alias ArtifactAi.Images
  alias ArtifactAi.Artifacts.Prompt
  alias ArtifactAi.Prompts

  @moduledoc false

  def mount(_params, _session, socket) do
    changeset =
      socket.assigns.current_user
      |> Ecto.build_assoc(:prompts)
      |> Prompt.changeset()

    images = Images.list()

    {:ok, assign(socket, form: to_form(changeset), images: images)}
  end

  def handle_event("validate", %{"prompt" => params}, socket) do
    changeset =
      socket.assigns.current_user
      |> Ecto.build_assoc(:prompts)
      |> Prompt.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("submit", %{"prompt" => params}, socket) do
    # todo: move this to a helper function
    #        with {:ok, result} <- OpenAI.Images.generate(params["prompt"], size: "1024x1024"),
    #             %{"data" => [%{"url" => url}]} <- result,
    with url <- "https://placekitten.com/1000",
         {:ok, multi} <- Images.create(Map.put(params, "url", url), socket.assigns.current_user),
         %{prompt: prompt, image: image} <- multi do
      {:noreply, redirect(socket, to: ~p"/e/#{shortid(prompt.id)}/#{shortid(image.id)}")}
    else
      {:error, error} ->
        {:noreply, socket}
    end
  end

  defp shortid(id), do: id |> String.split("-") |> List.first()
end