defmodule EVMRunner do
  @moduledoc """
  Allows you to run raw evm code.

  Eg.

  $ mix run apps/blockchain/scripts/evm_runner.ex --code 600360050160005260206000f3 --gas-limit 27

  10:11:11.929 [debug] Gas Remaining: 3

  10:11:11.936 [debug] Result: <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8>>

  """
  require Logger
  alias EVM.{ExecEnv, VM}
  alias EVM.Mock.MockAccountRepo
  alias EVM.Mock.MockBlockHeaderInfo

  def run() do
    {
      args,
      _
    } =
      OptionParser.parse!(System.argv(),
        switches: [
          code: :string,
          address: :string,
          originator: :string,
          timestamp: :integer,
          gas_limit: :integer
        ]
      )

    account_repo = MockAccountRepo.new()

    block_header_info =
      MockBlockHeaderInfo.new(%{
        timestamp: Keyword.get(args, :timestamp, 0)
      })

    gas_limit = Keyword.get(args, :gas_limit, 2_000_000)
    code_hex = Keyword.get(args, :code, "")
    machine_code = Base.decode16!(code_hex, case: :mixed)
    address = args |> Keyword.get(:address, "") |> Base.decode16()
    originator = args |> Keyword.get(:originator, "") |> Base.decode16()

    exec_env = %ExecEnv{
      machine_code: machine_code,
      address: address,
      originator: originator,
      account_repo: account_repo,
      block_header_info: block_header_info
    }

    {gas_remaining, _sub_state, _exec_env, result} = VM.run(gas_limit, exec_env)

    _ =
      Logger.debug(fn ->
        "Gas Remaining: #{gas_remaining}"
      end)

    _ =
      Logger.debug(fn ->
        "Result: #{inspect(result)}"
      end)
  end
end

EVMRunner.run()
