defmodule ExWire.Packet.Capability.Par do
  alias ExWire.Config
  alias ExWire.Packet.Capability
  alias ExWire.Packet.Capability.Par

  @behaviour Capability

  @name "par"

  @version_to_packet_types %{
    1 => [
      Par.WarpStatus,
      Par.NewBlockHashes,
      Par.Transactions,
      Par.GetBlockHeaders,
      Par.BlockHeaders,
      Par.GetBlockBodies,
      Par.BlockBodies,
      Par.NewBlock,
      Par.GetNodeData,
      Par.NodeData,
      Par.GetReceipts,
      Par.Receipts,
      Par.GetSnapshotManifest,
      Par.SnapshotManifest,
      Par.GetSnapshotData,
      Par.SnapshotData
    ]
  }

  @version_to_packet_count %{
    1 => 21
  }

  @available_versions Map.keys(@version_to_packet_types)
  @configured_versions Config.caps()
                       |> Enum.filter(fn cap -> cap.name == @name end)
                       |> Enum.map(fn cap -> cap.version end)

  @supported_versions Enum.filter(@available_versions, fn el ->
                        Enum.member?(@configured_versions, el)
                      end)

  @impl true
  def get_name() do
    @name
  end

  @impl true
  def get_supported_versions() do
    @supported_versions
  end

  @impl true
  def get_packet_types(version),
    do: Map.get(@version_to_packet_types, version, :unsupported_version)

  @impl true
  def get_packet_count(version),
    do: Map.get(@version_to_packet_count, version, :unsupported_version)
end
