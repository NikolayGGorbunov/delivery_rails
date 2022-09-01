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
      input :user if action_name == 'new'
      input :weight
      input :length
      input :width
      input :height
      input :start_point
      input :end_point
      if action_name.in?(%w[edit update])
        label :aasm_state
        select :aasm_state, resource.aasm.states(permitted: true).map{|elem| elem.name.to_s}.push(resource.aasm_state)
      end
    end

    actions
  end

  controller do
    def create
      resource = Packages::Create.run(params.fetch(:package).merge(user: User.find(params.fetch(:package)[:user_id])))
      redirect_to admin_package_path(resource.result)
    end

    def edit
      package = Package.find(params[:id])
      Packages::Update.new(package.attributes)
    end

    def update
      package = Package.find(params[:id])
      resource = Packages::Update.run(**params.permit![:package], package: package)
      redirect_to admin_package_path(resource.result)
    end

    def destroy
      Packages::Destroy.run(package: Package.find(params[:id]))
      redirect_to admin_packages_path
    end
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
