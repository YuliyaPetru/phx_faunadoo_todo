defmodule PhxFaunaTodo.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhxFaunaTodo.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        completed: true,
        todo: "some todo"
      })
      |> PhxFaunaTodo.Todos.create_todo()

    todo
  end
end
