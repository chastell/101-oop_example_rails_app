# app/services/lock_service.rb
require Rails.root.join('lib/lock')

class LockService
  def initialize(user_id:, item_id:, lock: Lock.new)
    @user_id = user_id
    @item_id = item_id
    @lock = lock
    # interesting side note - that would fail miserably in Python
    # did you know why?
  end

  def call
    lock.command = 'LOCK'
    lock.argument_1 = user_id
    lock.argument_2 = item_id
    lock.execute_command == 1
  end

  private

  attr_reader :user_id, :item_id, :lock
end
