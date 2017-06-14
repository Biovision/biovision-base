class CleanTokensJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Token.where(active: false).where('updated_at < ?', 1.month.ago).delete_all
    Token.where('last_used < ?', 1.year.ago).delete_all
  end
end
