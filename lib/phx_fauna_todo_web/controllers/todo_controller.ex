defmodule PhxFaunaTodoWeb.TodoController do
  use PhxFaunaTodoWeb, :controller

  action_fallback PhxFaunaTodoWeb.FallbackController

  def index(conn, _params) do
    query = """
      Todo.all()
    """
    execute_query(query, conn)
  end

  def create(conn, %{"todo" => todo_params}) do
    content = Map.get(todo_params, "todo", "")
    completed = Map.get(todo_params, "completed", false)

    query = """
      Todo.create({"todo": "#{content}", "completed": #{completed}})
    """

    execute_query(query, conn)
  end

  def show(conn, %{"id" => id}) do
    query = """
      Todo.byId(#{id})
    """

    execute_query(query, conn)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do

    query = """
      let toEdit = Todo.byId(#{id});
      toEdit.update({ #{Jason.encode!(todo_params)} })
    """

    execute_query(query, conn)
  end

  def delete(conn, %{"id" => id}) do
    query = """
      let toDelete = Todo.byId(#{id})
      toDelete.delete()
    """

    execute_query(query, conn)
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
