defmodule Discbot.Consumer do
    use Nostrum.Consumer
    use HTTPoison.Base
    alias Nostrum.Api

    def start_link do
        Consumer.start_link(__MODULE__)
    end

    def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
        cond do
            msg.content == "!ping" -> Api.create_message(msg.channel_id, "pong")
            msg.content == "!pong" -> Api.create_message(msg.channel_id, "ping")
            msg.content == "!react" -> Api.create_reaction!(msg.channel_id, msg.id, "😏")
            String.starts_with?(msg.content, "!react with ") -> Api.create_reaction!(msg.channel_id, msg.id, Enum.at(String.split(msg.content, " "), 2))
            msg.content == "!ppt" -> Api.create_message(msg.channel_id, "Comando inválido. Use !ppt **pedra** | **papel** | **tesoura**")
            String.starts_with?(msg.content, "!ppt ") -> evaluate_ppt(msg)
            msg.content == "!forza" -> evaluate_forza(msg)
            msg.content == "!funfact" -> evaluate_funfact(msg)
            true -> :ok
        end
    end

    def handle_event(_) do
        :ok
    end

    defp evaluate_ppt(msg) do
        aux = String.split(msg.content)

        if Enum.count(aux) == 2 do
            Api.create_message(msg.channel_id, "OK")
        else
            Api.create_message(msg.channel_id, "Comando inválido. Use !ppt **pedra** | **papel** | **tesoura**")
        end

    end

    defp evaluate_forza(msg) do
        imagem = getApiResponse("https://forza-api.tk")["image"]

        Api.create_message(msg.channel_id, imagem)
    end

    defp evaluate_funfact(msg) do
        fact = getApiResponse("https://asli-fun-fact-api.herokuapp.com/")["data"]["fact"]
        Api.create_message(msg.channel_id, fact)
    end

    defp getApiResponse(url) do
        response = HTTPoison.get! url
        JSON.decode!(response.body)
    end
end
