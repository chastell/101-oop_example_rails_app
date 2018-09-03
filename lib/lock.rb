# lib/lock.rb
class Lock
  attr_accessor :command, :argument_1, :argument_2

  def execute_command
    if !argument_1 || !argument_2 || command != 'LOCK'
      raise ArgumentError, 'Bad arguments provided'
    end
    [0, 1].sample # hey, external API can always fail!
  end
end
