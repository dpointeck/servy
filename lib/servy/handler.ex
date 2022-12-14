defmodule Servy.Handler do 
    def handle(request) do
        request 
        |> parse 
        |> log
        |> route 
        |> format_response
    end

    def log(conv), do: IO.inspect conv

    def parse(request) do
        [method, path, _] =
            request
            |> String.split("\n")
            |> List.first
            |> String.split(" ")

         %{ method: method, path: path, resp_body: "" }
    end

    def route(conv) do
        if conv.path == "/wildthings" do 
            %{ conv | resp_body: "Bears, Lions, Tigers" }
        else
            %{ conv | resp_body: "Bears" }
        end
    end

    def format_response(conv) do
        """
        HTTP/1.1 200 OK
        Content-Type: text/html
        Content-Length: #{String.length(conv.resp_body)}

        #{conv.resp_body}
        """
    end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
"""

response = Servy.Handler.handle(request)

IO.puts response