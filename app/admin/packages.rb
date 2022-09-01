ActiveAdmin.register Package do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :first_name, :second_name, :third_name, :email, :phone, :weight, :length, :width, :height, :start_point, :end_point, :distance, :price, :user_id, :aasm_state, :created_at, :updated_at

  actions :index, :show, :edit, :new, :update, :create, :destroy

  form do |f|
    inputs 'Parameters' do
      input :weight
      input :length
      input :width
      input :height
    end

    actions
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:first_name, :second_name, :third_name, :email, :phone, :weight, :length, :width, :height, :start_point, :end_point, :distance, :price, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
