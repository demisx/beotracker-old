module Controllers
  module SessionHelpers

    # Logs in resource via Devise helper method
    def login(resource)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      resource.user.present? ? sign_in(resource.user) : sign_in(resource)
    end

    def log_in_stubbed(resource = double('resource'))
      user = resource.user || resource
      if user.nil?
        request.env['warden'].stub(:authenticate!).and_throw(:warden, {:scope => :user})
        controller.stub :current_user => nil
      else
        request.env['warden'].stub :authenticate! => resource
        controller.stub :current_user => resource
      end
    end
  end
end
