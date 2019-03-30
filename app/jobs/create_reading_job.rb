class CreateReadingJob < ApplicationJob
  queue_as :default

  def perform(*args)
    attributes = args.first
    Reading.create(attributes)
  end
end
