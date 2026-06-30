module Ver1
  module Contracts
    class TaskCreateContract < TaskContractBase
      params do
        required(:title).filled(:string)
        required(:description).filled(:string)
        optional(:status)
        required(:scheduled_at).filled(:date_time)
        required(:recurrence)
        required(:tags).array(:string)
      end

      rule(:status) do
        value = Enums::TaskStatus::ACTIVE
      end
    end
  end
end
