module Repositories
  class TasksRepo
    include ::Enums

    def all(filter)
      all_root_tasks = Task.readonly.includes(:tags).root.to_a
      all_derived_tasks = Task.readonly.includes(:tags).where(root_id: all_root_tasks.map(&:id)).to_a
      derived_tasks = []
      tasks = []

      all_derived_tasks.each do |task|
        next unless will_be_between_dates?(task.recurrence, task.rescheduled_at, filter.start_date, filter.end_date)
        derived_tasks.push(task)
      end

      all_root_tasks.each do |task|
        next unless will_be_between_dates?(task.recurrence, task.scheduled_at, filter.start_date, filter.end_date)
        tasks.push(create_future_tasks(task, filter.start_date, filter.end_date))
      end

      tasks.each_with_index do |task, i|
        existing_task = derived_tasks.find { |derived_task|
          derived_task.scheduled_at == task.scheduled_at
          && derived_task.root_id == task.id
        }
        next if existing_task.nil?
        task[i] = existing_task
      end

      tasks
    end

    def create(task, tag_names)
      new_task = Task.new(
        title: task.title,
        description: task.description,
        status: task.status,
        scheduled_at: task.scheduled_at,
        recurrence: task.recurrence
      )
      new_task.save

      ::Tag.upsert_from_names(tag_names)
      tag_ids = ::Tag.where(name: tag_names).pluck(:id)
      new_task.tags = ::Tag.where(id: tag_ids)
      new_task.save
      new_task.readonly!

      if task.recurrence.type == RecurrenceType::ONCE
        return new_task
      end

      new_task.root_id = new_task.id
      new_task.id = 0

      new_task
    end

    def update_by_id(task, tag_names = nil)
      db_task = Task.includes(:tags).where(id: id).first
      raise ActiveRecord::RecordNotFound if db_task.nil?

      unless Task.root?(db_task)
        task.rescheduled_at = task.scheduled_at
        task.scheduled_at = nil
      end

      db_task.update(task.compact)
      db_task.save

      if tag_names.present?
        ::Tag.upsert_from_names(tag_names)
        db_task.tags = ::Tag.where(name: tag_names)
        db_task.save
      end
      db_task.readonly!

      db_task
    end

    def update_by_uid(task, tag_names = nil)
      root_id, scheduled_at = Types::TaskUid.split(task.uid)
      task.uid = nil
      root_task = Task.readonly.includes(:tags).where(id: root_id).first
      raise ActiveRecord::RecordNotFound if root_task.nil?

      tag_names = root_task.tags.map(&:name) if tag_names.nil?
      rescheduled_at = task.scheduled_at

      dup_task = root_task.dup
      dup_task.scheduled_at = scheduled_at
      dup_task.created_at = root_task.created_at

      new_task = create(dup_task, tag_names)
      unless rescheduled_at.nil?
        saved_task = Task.where(id: new_task.id).first
        saved_task.rescheduled_at = rescheduled_at
        saved_task.save
        saved_task.readonly!
        new_task = saved_task
      end

      new_task
    end

    def delete(id)
      task = Task.includes(:tags).where(id: id).first
      raise ActiveRecord::RecordNotFound if task.nil?

      return 0 unless Task.root?(task)

      count += (Task.where(root_id: id).destroy_all).count
      task.destroy

      count + 1
    end

    private

    def will_be_between_dates?(recurrence, scheduled_at, start_date, end_date)
      case recurrence[:type]
      when RecurrenceType::YEARLY
        temp_task = scheduled_at.change(year: start_date.year)
        temp_task.between?(start_date, end_date)
      when RecurrenceType::MONTHLY
        temp_task = scheduled_at.change(year: start_date.year, month: start_date.month)
        temp_task.between?(start_date, end_date)
      when RecurrenceType::WEEKLY
        weekdays = recurrence[:week_days]
        (start_date..end_date).each do |in_between_date|
          return true if weekdays.include?(in_between_date.strftime("%A").downcase)
        end
        false
      when RecurrenceType::ON_EVEN
        (start_date..end_date).each do |in_between_date|
          return true if in_between_date.day % 2 == 0
        end
        false
      when RecurrenceType::ON_ODD
        (start_date..end_date).each do |in_between_date|
          return true if in_between_date.day % 2 == 1
        end
        false
      else true
      end
    end

    def create_future_tasks(task, start_date, end_date)
      case task.recurrence[:type]
      when RecurrenceType::YEARLY
        if (start_date.month..end_date.month).cover?(task.scheduled_at.month)
          task.scheduled_at.change(year: start_date.year)
        else
          task.scheduled_at.change(year: end_date.year)
        end
        task
      when RecurrenceType::MONTHLY
        task.scheduled_at.change(year: start_date.year, month: start_date.month)
        tasks = [ task ]
        month = start_date.month + 1
        loop do
          if month == 13
            task.scheduled_at.change(year: end_date.year)
            month = 1
          end
          break if month > end_date.month

          task.scheduled_at.change(month: start_date.month)
          tasks.push(task)
          month += 1
        end
        tasks
      when RecurrenceType::WEEKLY
        tasks = []
        weekdays = task.recurrence[:week_days]
        (start_date..end_date).each do |in_between_date|
          next unless weekdays.include(in_between_date.strftime("%A").downcase)
          task.scheduled_at.change(year: in_between_date.year, month: in_between_date.month, day: in_between_date.day)
          tasks.push(task)
        end
        tasks
      when RecurrenceType::ON_EVEN
        tasks = []
        (start_date..end_date).each do |in_between_date|
          next unless in_between_date.day % 2 == 0
          task.scheduled_at.change(year: in_between_date.year, month: in_between_date.month, day: in_between_date.day)
          tasks.push(task)
        end
        tasks
      when RecurrenceType::ON_ODD
        tasks = []
        (start_date..end_date).each do |in_between_date|
          next unless in_between_date.day % 2 == 1
          task.scheduled_at.change(year: in_between_date.year, month: in_between_date.month, day: in_between_date.day)
          tasks.push(task)
        end
        tasks
      when RecurrenceType::DAILY
        tasks = []
        (start_date..end_date).each do |in_between_date|
          task.scheduled_at.change(year: in_between_date.year, month: in_between_date.month, day: in_between_date.day)
          tasks.push(task)
        end
        tasks
      else []
      end
    end
  end
end
