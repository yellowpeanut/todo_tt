module Ver1
  module  Contracts
    class TaskUpdateContract < TaskContractBase
      params do
        optional(:uid).maybe(:string)
        optional(:id).maybe(:integer)
        optional(:title).maybe(:string)
        optional(:description).maybe(:string)
        optional(:status).maybe(:string)
        optional(:scheduled_at).maybe(:date_time)
        optional(:recurrence)
        optional(:tags).array(:string)
      end

      rule(:uid, :id) do
        if values[:id].nil? && values[:uid].nil?
          key.failure("either 'id' or 'uid' must be provided")
        elsif values[:id].present? && values[:uid].present?
          key.failure("cannot provide both 'id' and 'uid'")
        end
      end

      rule(:title, :description, :status, :scheduled_at, :recurrence, :tags) do
        if values.all.instance_of?(NilClass)
          base.failure("please provide fields to update")
        end
      end
    end
  end
end
