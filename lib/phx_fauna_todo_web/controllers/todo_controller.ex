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
  end
end
