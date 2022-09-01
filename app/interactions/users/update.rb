module Users
  class Update < ActiveInteraction::Base
    object :user, class: User
    string :first_name, :second_name, :third_name, :phone
    email  :email

    def execute
      user.first_name = first_name if first_name.present?
      user.second_name = second_name if second_name.present?
      user.third_name = third_name if third_name.present?
      user.email = email if email.present?
      user.phone = phone if phone.present?

      errors.merge!(user.errors) unless user.save

      user
    end

    private

  end
end
