module Features
  module SelectDateHelpers
    def select_date(date, options = {})
      field = options[:from]
      base_id = find(:xpath, ".//label[contains(.,'#{field}')]")[:for]
      month, year = date.split(",")
      select year,  :from => "#{base_id}_1i"
      select month, :from => "#{base_id}_2i"
    end
  end
end