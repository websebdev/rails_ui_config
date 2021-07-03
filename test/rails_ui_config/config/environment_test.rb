require "test_helper"

class RailsUiConfig::Config::EnvironmentTest < ActiveSupport::TestCase
  test "find returns an instance of Environment" do
    assert_instance_of RailsUiConfig::Config::Environment, environment
  end

  test "fields returns an array of Field instances" do
    fields = environment.fields

    assert_instance_of Array, fields

    fields.each do |field|
      assert_instance_of RailsUiConfig::Config::Environment::Field, field
    end
  end

  test "update with no argument succeeds" do
    assert environment.update
  end

  test "update with a boolean option succeeds" do
    environment = RailsUiConfig::Config::Environment.find(:development)

    environment.update({"cache_classes": "true"})
    environment = RailsUiConfig::Config::Environment.find(:development)
    assert environment.fields.find { |field| field.name == :cache_classes}.value

    environment.update({"cache_classes": "false"})
    environment = RailsUiConfig::Config::Environment.find(:development)
    refute environment.fields.find { |field| field.name == :cache_classes}.value
  end

  test "update with a symbol option succeeds" do
    environment = RailsUiConfig::Config::Environment.find(:development)

    environment.update({"cache_store": "mem_cache_store"})
    environment = RailsUiConfig::Config::Environment.find(:development)
    assert_equal :mem_cache_store, environment.fields.find { |field| field.name == :cache_store}.value

    environment.update({"cache_store": "memory_store"})
    environment = RailsUiConfig::Config::Environment.find(:development)
    assert_equal :memory_store, environment.fields.find { |field| field.name == :cache_store}.value
  end

  test "update with a hash option succeeds" do
    environment = RailsUiConfig::Config::Environment.find(:development)

    environment.update({"headers": "{'New_Key' => 'new_value'}"})
    environment = RailsUiConfig::Config::Environment.find(:development)
    assert_equal(
      "{'New_Key' => 'new_value'}",
      environment.fields.find { |field| field.name == :headers && field.parent == :public_file_server }.value
    )

    environment.update({"headers": "{'New_Key' => 'another_new_value'}"})
    environment = RailsUiConfig::Config::Environment.find(:development)
    assert_equal(
      "{'New_Key' => 'another_new_value'}",
      environment.fields.find { |field| field.name == :headers && field.parent == :public_file_server }.value
    )
  end

  test "name is an attribute accessor" do
    assert_equal :development, environment.name
  end

  private

  def environment
    @enviroment ||= RailsUiConfig::Config::Environment.find(:development)
  end
end
