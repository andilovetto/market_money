class ErrorSerializer
  def self.error_handler(error)
    {
      "errors": [
        {
          "detail": error.message
        }
      ]
    }
  end
end