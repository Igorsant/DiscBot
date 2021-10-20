defmodule Discbot.Consumer do
    use Nostrum.Consumer
    alias Nostrum.Api

    def start_link do
        Consumer.start_link(__MODULE__)
    end

    def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
        cond do
            msg.content == "!ping" -> Api.create_message(msg.channel_id, "pong")
            msg.content == "!pong" -> Api.create_message(msg.channel_id, "ping")
            msg.content == "!react" -> Api.create_reaction!(msg.channel_id, msg.id, "😏")
            #String.starts_with?(msg.content, "!react with ") -> Api.create_reaction!(msg.channel_id, msg.id, elem(String.split(msg.content, " "), 2))
            true -> :ok
        end
    end

    def handle_event(_) do
        :ok
    end
end
