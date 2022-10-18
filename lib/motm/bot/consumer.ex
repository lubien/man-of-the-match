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

      "!import-messages-to-man-of-the-match" ->
        {:ok, messages} = Nostrum.Api.get_channel_messages(msg.channel_id, 100)

        # messages |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
        msg.guild_id |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)

        messages =
          messages
          |> Enum.map(&Map.put(&1, :guild_id, msg.guild_id))

        Motm.Repo.transaction(fn ->
          for msg <- messages do
            Discord.import_from_discord(msg)
          end
        end)

      _ ->
        channel =
          msg.channel_id
          |> Integer.to_string()
          |> Discord.get_discord_channel_by_discord_id()

        channel |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)

        if channel do
          Discord.import_from_discord(msg)
        end

        :ignore
    end
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    :noop
  end
end
