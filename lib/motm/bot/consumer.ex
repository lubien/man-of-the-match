defmodule Motm.Bot.Consumer do
  use Nostrum.Consumer

  alias Motm.Discord

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    msg |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)

    case msg.content do
      "!add-channel-to-man-of-the-match" ->
        {:ok, channel} = Nostrum.Api.get_channel(msg.channel_id)
        channel |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)

        {:ok, _channel} = Discord.create_discord_channel(%{
          name: channel.name,
          discord_id: Integer.to_string(channel.id),
          guild_id: Integer.to_string(channel.guild_id),
        },
          on_conflict: {:replace, [:name]},
          conflict_target: [:discord_id]
        )

      _ ->
        channel =
          msg.channel_id
          |> Integer.to_string()
          |> Discord.get_discord_channel_by_discord_id()

        channel |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)

        if channel do
          add_to_man_of_the_match(msg)
        end

        :ignore
    end
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    :noop
  end

  def add_to_man_of_the_match(msg) do
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
    message |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
  end
end
