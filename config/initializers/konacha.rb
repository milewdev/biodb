# See https://github.com/jfirebaugh/konacha#configuration
Konacha.configure do |config|
  config.spec_dir     = "test/coffeescripts"
  config.spec_matcher = /_test\./
  config.stylesheets  = %w(application)
  config.driver       = :webkit
end if defined?(Konacha)
