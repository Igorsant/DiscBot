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
            msg.content == "!checkGamePrice" -> Api.create_message(msg.channel_id, "Comando inválido. Insira um espaço após o comando e o nome de um jogo.")
            String.starts_with?(msg.content, "!checkGamePrice ") -> evaluate_game_price(msg)
            true -> :ok
        end
    end

    def handle_event(_) do
        :ok
    end

    defp get_api_response(url) do
        response = HTTPoison.get! url
        JSON.decode!(response.body)
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

    defp evaluate_game_price(msg) do
        aux = String.split(msg.content)
        game = Enum.join(Enum.filter(aux, fn i -> i != "!checkGamePrice" end), "%20")
        data = get_api_response("https://www.cheapshark.com/api/1.0/games?title=#{game}")
        data = Enum.filter(data, fn i ->
                    cond do
                        String.contains?(i["external"], game) -> i
                        true -> :ok
                    end
                end)
        data = Enum.map(data, fn i ->
                    "\n  Nome: #{i["external"]} | Menor preço: $#{i["cheapest"]} \n #{i["thumb"]}"
                end)

        #IO.inspect(data)

        data = if Enum.count(data) > 5 do
                    Enum.chunk_every(data, 5, 2, :discard)
                else
                    if Enum.count(data) > 0 do
                        Enum.chunk_every(data, Enum.count(data), 2, :discard)
                    end
                end

        if data != nil do
            data = Enum.fetch!(data, 0)
            Enum.each(data, fn i -> Api.create_message(msg.channel_id, i) end)
        else
            Api.create_message(msg.channel_id, "Nenhum jogo foi encontrado.")
        end
    end
end
