defmodule PhxFaunaTodo.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias PhxFaunaTodo.Todos.Todo
  alias PhxFaunaTodo.Faunarepo, as: Repo

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos do
    Repo.query("""
      Todo.all()
    """)
  end

  @doc """
  Gets a single todo.

  """
  def get_todo!(id) do
    Repo.query("""
      Todo.byId(#{id})
    """)
  end


  @doc """
  Creates a todo.

  ## Examples

  """
  def create_todo(%{todo: todo, completed: completed}) do
    Repo.query("""
    Todo.create({"todo": "#{todo}", "completed": #{completed}})
    """)
  end

  @doc """
  Updates a todo.

  """
  def update_todo(%{id: id, todo_params: todo_params}) do
    update_parts = todo_params
      |> Enum.map(fn {key, value} -> 
        # Check if the value is a boolean or a string to format it correctly
        formatted_value = case value do
          true -> "true"
          false -> "false"
          _ -> "\"#{value}\"" # Assuming all other values are strings, add quotes
        end

        "#{key}: #{formatted_value}"
      end)
      |> Enum.join(",\n    ")
    
    query = """
      let todo = Todo.byId("#{id}")
      todo.update({
        #{update_parts}
      })
    """

    Repo.query(query)

  end

  @doc """
  Deletes a todo.

  ## Examples

  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end
end
