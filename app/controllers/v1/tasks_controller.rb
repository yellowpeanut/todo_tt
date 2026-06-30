require_relative "../../../lib/ver1/services/tasks_service"
require_relative "../../../lib/ver1/contracts/task_get_contract"
require_relative "../../../lib/ver1/contracts/task_create_contract"
require_relative "../../../lib/ver1/contracts/task_update_contract"
require_relative "../../../lib/ver1/contracts/task_delete_contract"

module V1
  class TasksController < ApplicationController
    include ::Ver1::Services, ::Ver1::Contracts, ::Ver1::Requests
    before_action :setup

    def index
      contract_result = TaskGetContract.new.call(@params)
      unless contract_result.success?
        return render json: { error: contract_result.errors.to_h }, status: :bad_request
      end

      response = @tasks_service.get(TaskGetRequest.new(contract_result.to_h))

      render json: response.to_h, status: :ok
    end

    def create
      contract_result = TaskCreateContract.new.call(@params)
      unless contract_result.success?
        return render json: { error: contract_result.errors.to_h }, status: :unprocessable_entity
      end

      response = @tasks_service.create(TaskCreateRequest.new(contract_result.to_h))

      render json: response.to_h, status: :created
    end

    def update
      contract_result = TaskUpdateContract.new.call(@params)
      unless contract_result.success?
        return render json: { error: contract_result.errors.to_h }, status: :unprocessable_entity
      end

      response = @tasks_service.update(TaskUpdateRequest.new(contract_result.to_h))

      render json: response.to_h, status: :ok
    end

    def delete
      contract_result = TaskDeleteContract.new.call(@params)
      unless contract_result.success?
        return render json: { error: contract_result.errors.to_h }, status: :unprocessable_entity
      end

      response = @tasks_service.delete(TaskDeleteRequest.new(contract_result.to_h))

      render json: response.to_h, status: :ok
    end

    private

    def setup
      @params = params.permit!.to_h
      @tasks_service = TasksService.new
    end
  end
end
