require 'test_helper'

class LockServiceTest < ActiveSupport::TestCase
  MockedSuccessfulLock = Struct.new(:command, :argument_1, :argument_2) do
    def execute_command
      1
    end

    def inspect_fields
      [command, argument_1, argument_2]
    end
  end

  MockedFailedLock = Struct.new(:command, :argument_1, :argument_2) do
    def execute_command
      0
    end

    def inspect_fields
      [command, argument_1, argument_2]
    end
  end

  test 'sets fields correctly when calling LockService' do
    lock_object = MockedSuccessfulLock.new
    service = LockService.new(user_id: 1, item_id: 2, lock: lock_object)
    service.call
    assert_equal ['LOCK', 1, 2], lock_object.inspect_fields
  end

  test 'returns false when Lock returns 0' do
    lock_object = MockedFailedLock.new
    service = LockService.new(user_id: 1, item_id: 2, lock: lock_object)
    assert !service.call
  end

  test 'returns true when Lock returns 1' do
    lock_object = MockedSuccessfulLock.new
    service = LockService.new(user_id: 1, item_id: 2, lock: lock_object)
    assert service.call
  end
end
