# require 'rubygems'
require 'spork'

# Runs only upon initial start of the DRB server
Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  require File.expand_path("../../config/environment", __FILE__)

  # FIXME: Exit code of simplecov overwrites exit code of 'rake spec' of the CI script
  # sometimes resulting in a false success for a failed build
  #
  # if !ENV['DRB']
  #   require 'simplecov'
    
  #   SimpleCov.start 'rails' do
  #     add_filter '/spec/'
  #     add_filter '/config/'
  #     add_filter '/lib/'
  #     add_filter '/vendor/'
  #     coverage_dir "#{Rails.root}/public/coverage"
  #   end
  # end

  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/email/rspec'
  require 'pundit/rspec'

  # Comment out line below to enable default Selenium driver that uses Firefox
  Capybara.javascript_driver = :webkit

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  # Checks for pending migrations before tests are run.
  # If you are not using ActiveRecord, you can remove this line.
  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  RSpec.configure do |config|
    # Include Factory Girl syntax to simplify calls to factories 
    config.include FactoryGirl::Syntax::Methods
    config.include Features::SessionHelpers, type: :feature
    config.include Controllers::SessionHelpers, type: :controller
    config.include Controllers::MailerHelpers, type: :controller
    config.include Devise::TestHelpers, type: :controller


    # Custom helpers
    config.include Features::SelectDateHelpers, type: :feature
    
    # Configure the Rspec to only accept the new syntax on new projects, to avoid 
    # having the 2 syntax all over the place.
    config.expect_with :rspec do |c|
      c.syntax = :expect
    end
   
    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"
    config.include Capybara::DSL

    # Instead of randomly picking a GC stats sample from around the end of the test run.
    # Quick hack to see what our peak number of objects on the heap is
    heap_live_slot = 0
    factory_girl_results = {}
  
    config.before(:suite) do
      ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |name, start, finish, id, payload|
        factory_name = payload[:name]
        strategy_name = payload[:strategy]
        factory_girl_results[factory_name] ||= {}
        factory_girl_results[factory_name][strategy_name] ||= 0
        factory_girl_results[factory_name][strategy_name] += 1
      end
    end

    config.after(:each) do
      heap_live_slot = [heap_live_slot, GC.stat[:heap_live_slot]].max
    end
   
    config.after(:suite) do
      puts "\nMax heap object count: #{heap_live_slot}"
      puts Hash[factory_girl_results.sort]
    end
  end
end

# Runs each time specs are run
Spork.each_run do
  FactoryGirl.reload
  
  if ENV['DRB']
    require 'simplecov'

    SimpleCov.start 'rails' do
      add_filter '/spec/'
      add_filter '/config/'
      add_filter '/lib/'
      add_filter '/vendor/'
      coverage_dir "#{Rails.root}/public/coverage"
    end
  end
end
