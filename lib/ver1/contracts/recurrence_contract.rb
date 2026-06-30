module Ver1
  module  Contracts
    class RecurrenceContract < Dry::Validation::Contract
      include ::Enums
      params do
        required(:type).filled(:string)
        optional(:day_interval).maybe(:integer)
        optional(:week_days).array(:string)
        optional(:month_days).array(:integer)
      end

      rule(:type) do
        unless RecurrenceType.include?(value)
          key.failure("invalid recurrence type #{value}")
        end
      end

      rule(:type, :day_interval, :week_days, :month_days) do
        case values[:type]
        when RecurrenceType::DAILY
          if values[:day_interval].nil? or values[:day_interval] < 1
            key(:day_interval).failure("invalid day interval")
          end
        when RecurrenceType::WEEKLY
          if values[:week_days].nil?
            key(:week_days).failure("week_days must be an array")
          else
            values[:week_days].each do |day|
              unless WeekDays.include?(day)
                key.failure("invalid week day #{day}")
              end
            end
          end
        when RecurrenceType::MONTHLY
          if values[:month_days].nil?
            key(:month_days).failure("month_days must be an array")
          else
            values[:month_days].each do |day|
              if day < 1 or day > 31
                key(:month_days).failure("invalid month day #{day}, should be from 1 to 31")
              end
            end
          end
        else
          # no mistakes :O
        end
      end
    end
  end
end
