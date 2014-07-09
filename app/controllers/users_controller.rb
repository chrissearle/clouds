class UsersController < AuthenticatedController
  def edit

  end

  def update
    @current_user.email = params[:user][:email]

    unless @current_user.save
      render :action => :edit
    else
      redirect_to login_path, notice: 'User updated'
    end
  end
end
