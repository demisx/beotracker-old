Rake::Task['db:test:prepare'].enhance do
  Rails.env = "test"
  ActiveRecord::Base.establish_connection('test')
  Rake::Task['db:seed'].invoke
end