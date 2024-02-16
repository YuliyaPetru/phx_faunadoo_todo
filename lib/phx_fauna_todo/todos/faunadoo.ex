defmodule PhxFaunaTodo.Todos.Faunadoo do
  alias HTTPoison

  @fauna_url System.get_env("NEXT_PUBLIC_FAUNA_URL") || "https://db.fauna.com/query/1"

  def query(fql_expression) do
    key = System.get_env("FAUNA_KEY")

    headers = [
      {"accept", "application/json, text/plain, */*"},
      {"authorization", "Bearer #{key}"},
      {"x-format", "simple"},
      {"x-typecheck", "false"}
    ]

    body = %{
      "query" => fql_expression,
      "arguments" => %{}
    }

    case HTTPoison.post(@fauna_url, Jason.encode!(body), headers, hackney: [ssl: [{:versions, '[tlsv1.2]'}]]) do
      {:ok, %{status_code: 200, body: response_body}} ->
        {:ok, decode_response(response_body)}

      {:error, reason} ->
        {:error, "Failed to execute query: #{reason}"}
    end
  end

  defp decode_response(body) do
    Jason.decode!(body)["data"]
  end

end
