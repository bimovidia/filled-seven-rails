require 'test_helper'

class FilledSevenRailsTest < ActionDispatch::IntegrationTest
  teardown { clean_sprockets_cache }

  test "engine is loaded" do
    assert_equal ::Rails::Engine, FilledSeven::Rails::Engine.superclass
  end

  test "fonts are served" do
    get "/assets/Pe-icon-7-filled.eot"
    assert_response :success
    get "/assets/Pe-icon-7-filled.woff"
    assert_response :success
    get "/assets/Pe-icon-7-filled.ttf"
    assert_response :success
    get "/assets/Pe-icon-7-filled.svg"
    assert_response :success
  end

  test "stylesheets are served" do
    get "/assets/filled-seven.css"
    assert_filled_seven(response)
  end

  test "stylesheets contain asset pipeline references to fonts" do
    get "/assets/filled-seven.css"
    v = FilledSeven::Rails::F7_VERSION
    assert_match "/assets/Pe-icon-7-filled.eot?v=#{v}",  response.body
    assert_match "/assets/Pe-icon-7-filled.eot?#iefix&v=#{v}", response.body
    assert_match "/assets/Pe-icon-7-filled.woff?v=#{v}", response.body
    assert_match "/assets/Pe-icon-7-filled.ttf?v=#{v}",  response.body
    assert_match "/assets/Pe-icon-7-filled.svg?v=#{v}#Pe-icon-7-filled", response.body
  end

  test "stylesheet is available in a css sprockets require" do
    get "/assets/sprockets-require.css"
    assert_filled_seven(response)
  end

  test "stylesheet is available in a sass import" do
    get "/assets/sass-import.css"
    assert_filled_seven(response)
  end

  test "stylesheet is available in a scss import" do
    get "/assets/scss-import.css"
    assert_filled_seven(response)
  end

  test "helpers should be available in the view" do
    get "/icons"
    assert_response :success
    assert_select "i.pe-7f-album"
  end

  private

  def clean_sprockets_cache
    FileUtils.rm_rf File.expand_path("../dummy/tmp",  __FILE__)
  end

  def assert_filled_seven(response)
    assert_response :success
    assert_match(/font-family:\s*'Pe-icon-7-filled';/, response.body)
  end
end
