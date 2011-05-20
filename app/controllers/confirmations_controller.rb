class ConfirmationsController < Devise::PasswordsController
  skip_before_filter :authenticate_user!

  def show
    with_unconfirmed_confirmable do
      if @confirmable.has_no_password?
        do_show
      else
        do_confirm
      end
    end
    render_with_scope(:new) if !@confirmable.errors.empty?
  end


  protected

    def with_unconfirmed_confirmable
      @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
      if !@confirmable.new_record?
        @confirmable.only_if_unconfirmed yield
      end
    end

    def do_show
      @confirmation_token = params[:confirmation_token]
      @requires_password = true
      self.resource = @confirmable
      render_with_scope :show
    end

    def do_confirm
      @confirmable.confirm!
      set_flash_message :notice, :confirmed
      sign_in_and_redirect(resource_name, @confirmable)
    end
end
