module Ver1
  module Contracts
    class TaskDeleteContract < Dry::Validation::Contract
      params do
        optional(:uid).maybe(:string)
        optional(:id).maybe(:integer)
      end

      rule(:uid, :id) do
        if values[:id].nil? && values[:uid].nil?
          key.failure("either 'id' or 'uid' must be provided")
        elsif values[:id].present? && values[:uid].present?
          key.failure("cannot provide both 'id' and 'uid'")
        end
      end
    end
  end
end
