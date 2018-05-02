defmodule Slow do
  use Plug.Router
  plug :health_check
  plug Plug.RequestId
  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded]
  plug :match
  plug :dispatch

  @max_timeout_ms 120_000

  @index_html """
              <!doctype html>
              <style>body{width: 800px; margin: 0 auto; font-family: monospace; color: #222;}.footer{margin-top: 20px; color: #888;}</style>
              """ <>
                (Path.relative_to_cwd("./README.md")
                 |> File.read!()
                 |> Earmark.as_html!()) <>
                """
                <div class=footer> Built by <a href='http://minhajuddin.com/'>@minhajuddin</a> &copy; 2018
                | Source at <a href="https://github.com/webutil/slow">webutil/slow</a>
                | Powered by <a href='https://elixir-lang.org/'>Elixir</a></div>
                """

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(:ok, @index_html)
  end

  get "/timeout" do
    timeout = timeout(conn.params)

    if timeout <= @max_timeout_ms do
      :timer.sleep(timeout)

      conn
      |> put_resp_header("slow-timeout-ms", to_string(timeout))
      |> send_resp(:ok, "OK")
    else
      conn
      |> send_resp(
        :bad_request,
        "Bad input request. Maximum timeout allowed is #{@max_timeout_ms}ms got #{timeout}ms."
      )
    end
  end

  match _ do
    send_resp(conn, :not_found, "404, Not found.")
  end

  defp timeout(params) do
    round(
      parse_number(params["seconds"]) * 1000 + parse_number(params["second"]) * 1000 +
        parse_number(params["microsecond"]) + parse_number(params["microseconds"])
    )
  end

  defp parse_number(""), do: 0
  defp parse_number(nil), do: 0

  defp parse_number(number) do
    case Float.parse(number) do
      {f, ""} -> f
      _ -> 0
    end
  end

  def health_check(conn, _opts) do
    if conn.path_info == ["_health_check"] do
      conn
      |> send_resp(:ok, [])
      |> halt
    else
      conn
    end
  end
end
