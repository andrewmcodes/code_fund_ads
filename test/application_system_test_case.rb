require "test_helper"
require "minitest/rails/capybara"

Capybara.app_host = "http://#{ENV["TEST_APP_HOST"]}:#{ENV["TEST_PORT"]}"
Capybara.javascript_driver = :selenium
Capybara.run_server = false

# Configure the firefox driver capabilities & register
args = ["--no-default-browser-check", "--start-maximized", "--no-sandbox"]
caps = Selenium::WebDriver::Remote::Capabilities.firefox("firefoxOptions" => {"args" => args})
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: "http://#{ENV["SELENIUM_HOST"]}:#{ENV["SELENIUM_PORT"]}/wd/hub",
    desired_capabilities: caps
  )
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_firefox
end
