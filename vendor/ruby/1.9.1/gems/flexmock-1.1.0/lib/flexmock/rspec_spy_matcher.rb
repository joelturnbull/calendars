require 'flexmock/spy_describers'

class FlexMock
  module RSpecMatchers

    class HaveReceived
      include SpyDescribers

      def initialize(method_name)
        @method_name = method_name
        @args = nil
        @block = nil
        @times = nil
        @needs_block = nil
      end

      def matches?(spy)
        @spy = spy
        @options = {}
        @options[:times] = @times if @times
        @options[:with_block] = @needs_block unless @needs_block.nil?
        @spy.flexmock_received?(@method_name, @args, @options)
      end

      def failure_message_for_should
        describe_spy_expectation(@spy, @method_name, @args, @options)
      end

      def failure_message_for_should_not
        describe_spy_negative_expectation(@spy, @method_name, @args, @options)
      end

      def with(*args)
        @args = args
        self
      end

      def with_a_block
        @needs_block = true
        self
      end

      def without_a_block
        @needs_block = false
        self
      end

      def times(n)
        @times = n
        self
      end

      def never
        times(0)
      end

      def once
        times(1)
      end

      def twice
        times(2)
      end
    end

    def have_received(method_name)
      HaveReceived.new(method_name)
    end
  end
end

RSpec::configure do |config|
  config.include(FlexMock::RSpecMatchers)
end
