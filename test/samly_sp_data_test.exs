defmodule SamlySpDataTest do
  use ExUnit.Case
  alias Samly.SpData

  @sp_config1 %{
    id: "sp1",
    entity_id: "urn:test:sp1",
    certfile: "test/data/test.crt",
    keyfile: "test/data/test.pem"
  }

  @sp_config2 %{
    id: "sp1",
    entity_id: "urn:test:sp1",
    certificate: File.read!("test/data/test.crt"),
    key: File.read!("test/data/test.pem")
  }

  test "valid-sp-config-1" do
    %SpData{} = sp_data = SpData.load_provider(@sp_config1)
    assert sp_data.valid?
  end

  test "cert-unspecified-sp-config" do
    sp_config = %{@sp_config1 | certfile: ""}
    %SpData{cert: :undefined} = sp_data = SpData.load_provider(sp_config)
    assert sp_data.valid?
  end

  test "key-unspecified-sp-config" do
    sp_config = %{@sp_config1 | keyfile: ""}
    %SpData{key: :undefined} = sp_data = SpData.load_provider(sp_config)
    assert sp_data.valid?
  end

  test "inline cert and key" do
    %SpData{} = sp_data = SpData.load_provider(@sp_config2)
    assert sp_data.valid?
    assert sp_data.cert != :undefined
    assert sp_data.key != :undefined
  end

  test "invalid inline cert" do
    sp_config = %{@sp_config2 | id: "bad cert", certificate: "Bad Certificate"}
    %SpData{} = sp_data = SpData.load_provider(sp_config)
    refute sp_data.valid?
  end

  test "invalid inline key" do
    sp_config = %{@sp_config2 | id: "bad key", key: "Bad Key"}
    %SpData{} = sp_data = SpData.load_provider(sp_config)
    refute sp_data.valid?
  end

  test "invalid-sp-config-1" do
    sp_config = %{@sp_config1 | id: ""}
    %SpData{} = sp_data = SpData.load_provider(sp_config)
    refute sp_data.valid?
  end

  test "invalid-sp-config-2" do
    sp_config = %{@sp_config1 | certfile: "non-existent.crt"}
    %SpData{} = sp_data = SpData.load_provider(sp_config)
    refute sp_data.valid?
  end

  test "invalid-sp-config-3" do
    sp_config = %{@sp_config1 | keyfile: "non-existent.pem"}
    %SpData{} = sp_data = SpData.load_provider(sp_config)
    refute sp_data.valid?
  end

  test "invalid-sp-config-4" do
    sp_config = %{@sp_config1 | certfile: "test/data/test.pem"}
    %SpData{} = sp_data = SpData.load_provider(sp_config)
    refute sp_data.valid?
  end

  test "invalid-sp-config-5" do
    sp_config = %{@sp_config1 | keyfile: "test/data/bad_key.pem"}
    %SpData{} = sp_data = SpData.load_provider(sp_config)
    refute sp_data.valid?
  end
end
