# Igor Oliveira e Álbero Ítalo

# DiscBot

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `discbot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:discbot, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/discbot](https://hexdocs.pm/discbot).

## Running local environment

use **only git bash** to run this.

install the dependencies:

```bash
mix deps.get
```

copy the .env.example to .env file with:

```bash
cp .env.example .env
```

and put the token. After that, just run ./runlocal.sh like this:

```bash
./runLocal.sh
```

# Comandos do Bot no Discord:

!forza\
Descrição: Esse comando faz com que o bot envie uma mensagem com um url de uma imagem aleatoria do jogo Forza.\
Como usar: Enviar uma mensagem contendo somente o comando "!forza", qualquer outra mensagem será ignorada.

!funfact\
Descrição: Esse comando envia uma mensagem com um fato divertido.\
Como usar: Enviar uma mensagem contendo somente o comando "!funfact", qualquer outra mensagem será ignorada.

!norris\
Descrição: Envia uma mensagem com um piada aleatoria envolvendo Chuck Norris.\
Como usar: Enviar uma mensagem contendo somente o comando "!norris", qualquer outra mensagem será ignorada.

!checkGamePrice\
Descrição: Envia mensagens com no máximo 5 resultados contendo o nome, menor preço encontrado e uma imagem do jogo informado. Obs: o bot pode enviar informações sobre dlcs ou outras versões desse mesmo jogo ou franquia.\
Como usar: Enviar uma mensagem contendo o comando "!checkGamePrice", seguido de um espaço e o nome de um jogo. Caso não haja um espaço e o nome de um jogo após o comando, o mesmo será ignorado. Caso nenhum jogo for encontrado, o bot informará.

!free\
Descrição: Envia um jogo aleatório grátis com seu título, descrição, link para jogar e thumbnail.\
Como usar: Envie uma mensagem exatamente assim "!free".