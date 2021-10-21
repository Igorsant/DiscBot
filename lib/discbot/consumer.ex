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
            msg.content == "!norris" -> evaluate_chuck_norris(msg)
            true -> :ok
        end
    end

    def handle_event(_) do
        :ok
    end

    defp evaluate_ppt(msg) do
        aux = String.split(msg.content)

        if Enum.count(aux) == 2 do
            case Enum.fetch!(aux, 1) do
                "pedra" -> evaluate_stone(msg)
                "papel" -> evaluate_paper(msg)
                "tesoura" -> evaluate_scisor(msg)
                _ -> Api.create_message(msg.channel_id, "Comando inválido. Use !ppt **pedra** | **papel** | **tesoura**")
            end
        else
            Api.create_message(msg.channel_id, "Comando inválido. Use !ppt **pedra** | **papel** | **tesoura**")
        end
    end

    defp evaluate_stone(msg) do
        bot_element = Enum.random(0..2)

        case bot_element do
            0 -> Api.create_message(msg.channel_id, "O bot escolheu pedra. Houve um empate!")
            1 -> Api.create_message(msg.channel_id, "O bot escolheu papel. O bot venceu!")
            2 -> Api.create_message(msg.channel_id, "O bot escolheu tesoura. Você venceu!")
        end
    end

    defp evaluate_paper(msg) do
        bot_element = Enum.random(0..2)

        case bot_element do
            0 -> Api.create_message(msg.channel_id, "O bot escolheu pedra. Você venceu!")
            1 -> Api.create_message(msg.channel_id, "O bot escolheu papel. Houve um empate!")
            2 -> Api.create_message(msg.channel_id, "O bot escolheu tesoura. O bot venceu!")
        end
    end

    defp evaluate_scisor(msg) do
        bot_element = Enum.random(0..2)

        case bot_element do
            0 -> Api.create_message(msg.channel_id, "O bot escolheu pedra. O bot venceu!")
            1 -> Api.create_message(msg.channel_id, "O bot escolheu papel. Você venceu!")
            2 -> Api.create_message(msg.channel_id, "O bot escolheu tesoura. Houve um empate!")
        end
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
