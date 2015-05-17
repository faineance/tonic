defmodule Tonic.Handler do
  def init({:tcp, :http}, req, opts) do
    {:ok, req, opts}
  end

  def handle(req, state) do
    {method, req} = :cowboy_req.method(req)
    {param, req} = :cowboy_req.binding(:filename, req)

    headers = [{"content-type", "text/html"}]
    {:ok, file} = File.read "priv/pages/" <> param <> ".md"
    title = String.capitalize(param) 
    content = Earmark.to_html(file)     
    body = EEx.eval_file "priv/templates/index.html.eex", [content: content, title: title]
    {:ok, resp} = :cowboy_req.reply(200, headers, body, req) 
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end 
end
