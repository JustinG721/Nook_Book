defmodule NookBook.Data.Setup do

  @tables [
    NookBook.Data.GenericCache
  ]

  def setup do
    :mnesia.start()
    create_schema()
    create_tables()
  end

  def create_tables(), do: Enum.each(@tables, &create_table/1)

  def create_table(module) do
    case table_exists?(module.table_name()) do
      true -> {:ok, :already_created}
      false -> 
        :mnesia.create_table(
          module.table_name(), 
          attributes: module.table_fields(),
          type: module.table_type(),
          index: module.table_indexes(),
          disc_copies: nodes()
        )
    end
  end

  def table_exists?(table_name) do
    Enum.member?(:mnesia.system_info(:tables), table_name)
  end

  def wait_for_tables() do
    :mnesia.wait_for_tables(table_names(), 10_000)
  end

  def table_names, do: Enum.map(@tables, &apply(&1, :table_name, []))

  def create_schema do
    case schema_exists_anywhere?() do
      true -> {:ok, :already_created}
      false ->
        Enum.each(nodes(), fn n -> Node.spawn_link(n, &:mnesia.stop/0) end)
        :mnesia.create_schema(nodes())
        :mnesia.start()
        Enum.each(Node.list([:visible]), fn n -> Node.spawn_link(n, &:mnesia.start/0) end)
    end
  end

  def nodes, do: [node() | Node.list([:visible])]

  def schema_exists_anywhere?() do
    {answers, _} = :rpc.multicall(nodes(), NookBook.Data.Setup, :schema_exists?, [])
    Enum.any?(answers, &(&1))
  end

  def schema_exists?() do
    :mnesia.table_info(:schema, :disc_copies) != []
  end
end
