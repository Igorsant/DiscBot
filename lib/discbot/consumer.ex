defmodule Discbot.Consumer do
    use Nostrum.Consumer

    def start_link do
        Consumer.start_link(__MODULE__)
    end

    def handle_event(_) do 
        :ok
    end
end
