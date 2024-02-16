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

  # def index(conn, _params) do
  #   todos = Todos.list_todos()
  #   render(conn, :index, todos: todos)
  # end

  # def create(conn, %{"todo" => todo_params}) do
  #   with {:ok, %Todo{} = todo} <- Todos.create_todo(todo_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", ~p"/api/todos/#{todo}")
  #     |> render(:show, todo: todo)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   todo = Todos.get_todo!(id)
  #   render(conn, :show, todo: todo)
  # end

  # def update(conn, %{"id" => id, "todo" => todo_params}) do
  #   todo = Todos.get_todo!(id)

  #   with {:ok, %Todo{} = todo} <- Todos.update_todo(todo, todo_params) do
  #     render(conn, :show, todo: todo)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   todo = Todos.get_todo!(id)

  #   with {:ok, %Todo{}} <- Todos.delete_todo(todo) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
