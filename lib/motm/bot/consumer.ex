defmodule Motm.Bot.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias Motm.Repo
  alias Motm.Discord
  alias Motm.Discord.DiscordMessage

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    # msg |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)

    {:ok, channel} = Nostrum.Api.get_channel(msg.channel_id)
    channel |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)

    {:ok, user} = Discord.create_discord_user(%{
      discord_id: Integer.to_string(msg.author.id),
      username: msg.author.username,
      discriminator: msg.author.discriminator,
      avatar: msg.author.avatar
    },
      on_conflict: {:replace, [:avatar]},
      conflict_target: [:discord_id]
    )

    user |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)

    {:ok, message} = Discord.create_discord_message(%{
      discord_user_id: user.id,
      content: msg.content,
      channel_id: Integer.to_string(msg.channel_id),
      discord_id: Integer.to_string(msg.id),
      guild_id: Integer.to_string(msg.guild_id),
    },
      on_conflict: {:replace, [:content]},
      conflict_target: [:discord_id]
    )

    # {:ok, message} = Repo.insert(message_attrs, on_conflict: {:replace, [:content]})
    message |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)

    case msg.content do
      "!sleep" ->
        Api.create_message(msg.channel_id, "Going to sleep...")
        # This won't stop other events from being handled.
        Process.sleep(3000)

      "!ping" ->
        Api.create_message(msg.channel_id, "pyongyang!")

      "!raise" ->
        # This won't crash the entire Consumer.
        raise "No problems here!"

      _ ->
        :ignore
    end
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    :noop
  end
end
