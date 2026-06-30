module Errors
  class BadRequestError < StandardError
  end

  class NotFoundError < StandardError
  end

  class InternalServerError < StandardError
  end
end
