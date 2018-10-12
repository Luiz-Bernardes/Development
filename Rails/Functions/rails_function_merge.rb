def create
  @user = User.new(user_params.merge(category_id: category))
  if @user.save
    flash[:success] = "Usuário criado com sucesso!"
    redirect_to users_path
  else
    flash[:error] = "Favor verificar os erros do formulário!"
    render :new
  end
end