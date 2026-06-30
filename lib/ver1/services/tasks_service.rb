module Ver1
  module Services
    class TasksService
      include ::Errors, Responses, ::Repositories

      def initialize
        @tasks_repo = TasksRepo.new
      end

      def get(request)
        tasks = request.id.present? ? Task.find(request.id).first
                  : @tasks_repo.all(request)
        TaskGetResponse.new(tasks: tasks)

      rescue ActiveRecord::RecordNotFound => e
        raise NotFoundError.new(e.message)
      rescue => e
        raise InternalServerError.new(e.message)
      end

      def create(request)
        task = @tasks_repo.create(request, request.tags)
        TaskCreateResponse.new(
          id: task.id,
          title: task.title,
          description: task.description,
          status: task.status,
          scheduled_at: task.rescheduled_at.nil? ? task.scheduled_at : task.rescheduled_at,
          recurrence: task.recurrence,
          tags: task.tags.map(&:name),
          created_at: task.created_at,
          updated_at: task.updated_at,
        )
      rescue ActiveRecord::RecordInvalid => e
        raise BadRequestError.new(e.message)
      rescue => e
        raise InternalServerError.new(e.message)
      end

      def update(request)
        task = request.id.present? ? @tasks_repo.update_by_id(request, request.tags)
                 : @tasks_repo.update_by_uid(request, request.tags)
        TaskUpdateResponse.new(
          id: task.id,
          title: task.title,
          description: task.description,
          status: task.status,
          scheduled_at: task.rescheduled_at.nil? ? task.scheduled_at : task.rescheduled_at,
          recurrence: task.recurrence,
          tags: task.tags.map(&:name),
          created_at: task.created_at,
          updated_at: task.updated_at,
        )
      rescue ActiveRecord::RecordNotFound => e
        raise NotFoundError.new(e.message)
      rescue ActiveRecord::RecordInvalid => e
        raise BadRequestError.new(e.message)
      rescue => e
        raise InternalServerError.new(e.message)
      end

      def delete(request)
        count = @tasks_repo.delete(request.id)
        TaskDeleteResponse.new(count: count)

      rescue ActiveRecord::RecordNotFound => e
        raise NotFoundError.new(e.message)
      rescue => e
        raise InternalServerError.new(e.message)
      end
    end
  end
end
