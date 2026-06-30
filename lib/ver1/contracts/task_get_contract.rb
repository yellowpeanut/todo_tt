module Ver1
  module Contracts
    class TaskGetContract < Dry::Validation::Contract
      params do
        required(:start_date).filled(:date)
        required(:end_date).filled(:date)
      end

      rule(:start_date, :end_date) do
        date_diff = values[:end_date] - values[:start_date]
        if date_diff > 92
          base.failure("can't request for a period more them 92 days")
        end
        if values[:start_date] > values[:end_date]
          base.failure("start date should be later than the end date")
        end
      end
    end
  end
end
