defmodule Motm.Bot.Consumer do
  use Nostrum.Consumer

  alias Motm.Discord

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "!add-channel-to-man-of-the-match" ->
        {:ok, channel} = Nostrum.Api.get_channel(msg.channel_id)

        {:ok, _channel} = Discord.create_discord_channel(%{
          name: channel.name,
          discord_id: Integer.to_string(channel.id),
          guild_id: Integer.to_string(channel.guild_id),
        },
          on_conflict: {:replace, [:name]},
          conflict_target: [:discord_id]
        )

      "!import-messages-to-man-of-the-match" ->
        if Discord.can_import_from_channel?(Integer.to_string(msg.channel_id)) do
          Discord.import_latest_channel_messages(msg.guild_id, msg.channel_id)
        end

      _ ->
        if Discord.can_import_from_channel?(Integer.to_string(msg.channel_id)) do
          Discord.import_from_discord(msg)
          {:ok} = Nostrum.Api.create_reaction(msg.channel_id, msg.id, "✅")
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
