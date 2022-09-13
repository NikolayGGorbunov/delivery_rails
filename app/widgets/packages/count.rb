#frozen_string_literal: true

module Packages
  class Count < DefaultWidget
    def self.call(org_id, func = :all)
      arg = func == :sorted ? :user_id : nil
      new(org_id, arg).send(:exec)
    end

    private

    def exec
      output = to_output(@relation.count)
    end

    def to_output(input)
      if input.instance_of?(Hash)
        result = input.each_with_object([]) do |(id, amount), result|
          result << "User#{id} = #{amount}"
        end
        { text: 'Count of packages by users: ', data: "| #{result.join(' | ')} |" }
      else
        { text: 'Count of packages by users: ', data: input }
      end
    end
  end
end
