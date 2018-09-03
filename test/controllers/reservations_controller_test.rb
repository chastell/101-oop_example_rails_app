# test/controller/reservations_controller_test.rb
require 'test_helper'

class ReservationsControllerControllerTest < ActionDispatch::IntegrationTest
  SuccesfullLockService = Struct.new(:user_id, :item_id, keyword_init: true) do
    def call
      true
    end
  end

  FailedLockService = Struct.new(:user_id, :item_id, keyword_init: true) do
    def call
      false
    end
  end

  test 'returns HTTP bad_request when missing user_id' do
    ServiceProvider.register(:lock_service, LockService)
    post reservations_url, params: { item_id: 2 }
    assert_response :bad_request
  end

  test 'returns a JSON error when missing user_id' do
    ServiceProvider.register(:lock_service, LockService)
    post reservations_url, params: { item_id: 2 }
    assert_equal({ 'error' => 'Bad arguments' }, response.parsed_body)
  end

  test 'returns HTTP bad_request when missing item_id' do
    ServiceProvider.register(:lock_service, LockService)
    post reservations_url, params: { user_id: 2 }
    assert_response :bad_request
  end

  test 'returns a JSON error when missing item_id' do
    ServiceProvider.register(:lock_service, LockService)
    post reservations_url, params: { user_id: 1 }
    assert_equal({ 'error' => 'Bad arguments' }, response.parsed_body)
  end

  test 'returns emtpy JSON when service returns true' do
    ServiceProvider.register(:lock_service, SuccesfullLockService)
    post reservations_url, params: { user_id: 1, item_id: 2 }
    assert_equal({}, response.parsed_body)
  end

  test 'returns HTTP created when service returns true' do
    ServiceProvider.register(:lock_service, SuccesfullLockService)
    post reservations_url, params: { user_id: 1, item_id: 2 }
    assert_response :created
  end

  test 'returns empty JSON when service returns false' do
    ServiceProvider.register(:lock_service, FailedLockService)
    post reservations_url, params: { user_id: 1, item_id: 2 }
    assert_equal({}, response.parsed_body)
  end

  test 'returns HTTP conflict when service returns false' do
    ServiceProvider.register(:lock_service, FailedLockService)
    post reservations_url, params: { user_id: 1, item_id: 2 }
    assert_response :conflict
  end

  teardown do
    ServiceProvider.register(:lock_service, LockService)
  end
end
