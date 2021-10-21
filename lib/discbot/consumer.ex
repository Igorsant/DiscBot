defmodule Discbot.Consumer do
    use Nostrum.Consumer
    use HTTPoison.Base
    alias Nostrum.Api

    def start_link do
        Consumer.start_link(__MODULE__)
    end

    def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
        cond do
            msg.content == "!forza" -> evaluate_forza(msg)
            msg.content == "!funfact" -> evaluate_funfact(msg)
            msg.content == "!norris" -> evaluate_chuck_norris(msg)
            true -> :ok
        end
    end

    def handle_event(_) do
        :ok
    end

    defp evaluate_forza(msg) do
        imagem = get_api_response("https://forza-api.tk")["image"]

        Api.create_message(msg.channel_id, imagem)
    end

    defp evaluate_funfact(msg) do
        fact = get_api_response("https://asli-fun-fact-api.herokuapp.com/")["data"]["fact"]
        Api.create_message(msg.channel_id, fact)
    end

    defp evaluate_chuck_norris(msg) do
        rand = Enum.random(0..619)
        value = get_api_response("https://api.icndb.com/jokes")["value"]
        speak = Enum.fetch!(value, rand)["joke"]
        Api.create_message(msg.channel_id, speak)
    end

    defp get_api_response(url) do
        response = HTTPoison.get! url
        JSON.decode!(response.body)
    end
end
