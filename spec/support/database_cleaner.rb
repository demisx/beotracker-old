RSpec.configure do |config|

  # trunc_options = { except: %w[personality_test_templates personality_test_template_questions 
  #   personality_test_template_answers personality_traits] } 
  trunc_options = {}

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, trunc_options)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation, trunc_options
  end 

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end