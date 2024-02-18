defmodule PhxFaunaTodoWeb.TodoController do
  use PhxFaunaTodoWeb, :controller
  alias PhxFaunaTodo.Todos

  action_fallback PhxFaunaTodoWeb.FallbackController

  def index(conn, _params) do
    todos = Todos.list_todos()
    json(conn, todos)
  end

  def create(conn, %{"todo" => todo, "completed" => completed}) do
    newtodo = Todos.create_todo(%{todo: todo, completed: completed})
    json(conn, %{"todo" => newtodo })
  end

  def show(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)
    json(conn, todo)
  end

  def update(conn, %{"id" => id, "data" => todo_params}) do
    updated = Todos.update_todo(%{id: id, todo_params: todo_params})
    json(conn, %{"data" => updated })
  end

  def delete(conn, %{"id" => id}) do
    # query = """
    #   let toDelete = Todo.byId(#{id})
    #   toDelete.delete()
    # """

    # execute_query(query, conn)
  end

  defp execute_query(query, conn) do
    case PhxFaunaTodo.Todos.Faunadoo.query(query) do
      {:ok, result} ->
        conn
        |> put_status(:ok)
        |> json(result)

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Failed to execute query: #{reason}"})
    end
  end
end
