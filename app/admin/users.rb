ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :email, :encrypted_password, :first_name, :second_name, :third_name, :phone, :reset_password_token, :reset_password_sent_at, :remember_created_at

  actions :index, :show, :edit, :new, :update, :create, :destroy

  controller do

    after_update :update_user_packages

    private

    def update_user_packages(user)
      user.packages.each do |package|
        Packages::Update.run(**package.attributes, package: package, user: user)
      end
    end
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :first_name, :second_name, :third_name, :phone, :reset_password_token, :reset_password_sent_at, :remember_created_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
