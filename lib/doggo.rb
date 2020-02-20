require 'rspec/core'
require 'rspec/core/formatters/base_text_formatter'
require 'rspec/core/formatters/console_codes'

class Doggo < RSpec::Core::Formatters::BaseTextFormatter

  RSpec::Core::Formatters.register(
    self,
    :start,
    :example_started,
    :example_group_started,
    :example_group_finished,
    :example_passed,
    :example_pending,
    :example_failed
  )

  attr_accessor(
    :outstr,

    :example_running,
    :current_example_index,
    :group_level,
    :messages,

    :total_count,
    :passed_count,
    :pending_count,
    :failed_count
  )

  def initialize(output)
    @outstr                = output

    @example_running       = false
    @current_example_index = 0
    @group_level           = 0
    @messages              = []

    @total_count           = 0
    @passed_count          = 0
    @pending_count         = 0
    @failed_count          = 0

    super
  end

  def start(notification)
    self.total_count = notification.count
    super
  end

  def example_started(_notification)
    self.example_running        = true
    self.current_example_index += 1
  end

  def example_group_started(notification)
    self.outstr.puts() if self.group_level == 0
    self.outstr.puts("#{group_progress()} #{current_indentation}#{notification.group.description.strip}")

    self.group_level += 1
  end

  def example_group_finished(_notification)
    self.group_level -= 1 if self.group_level > 0
  end

  def example_passed(passed)
    self.outstr.puts(passed_output(passed.example))
    flush_messages

    self.passed_count   += 1
    self.example_running = false
  end

  def example_pending(pending)
    self.outstr.puts(
      pending_output(
        pending.example,
        pending.example.execution_result.pending_message
      )
    )

    flush_messages

    self.pending_count  += 1
    self.example_running = false
  end

  def example_failed(failure)
    self.outstr.puts(failure_output(failure.example))
    flush_messages

    self.failed_count   += 1
    self.example_running = false
  end

  def message(notification)
    if self.example_running
      self.messages << notification.message
    else
      self.outstr.puts("#{group_progress()} #{current_indentation}#{notification.message}")
    end
  end

  private

    def flush_messages
      self.messages.each do |message|
        self.outstr.puts("#{group_progress()} #{current_indentation(1)}#{message}")
      end

      self.messages.clear
    end

    def passed_output(example)
      RSpec::Core::Formatters::ConsoleCodes.wrap(
        "#{example_progress()} #{current_indentation}#{example.description.strip}",
        :success
      )
    end

    def pending_output(example, message)
      message = nil if message.downcase == 'temporarily skipped with xit'
      message = " (#{message})" unless message.nil? || message.empty?

      RSpec::Core::Formatters::ConsoleCodes.wrap(
        "#{example_progress()} #{current_indentation}PENDING#{message} - #{example.description.strip}",
        :pending
      )
    end

    def failure_output(example)
      RSpec::Core::Formatters::ConsoleCodes.wrap(
        "#{example_progress()} #{current_indentation}FAILED (#{next_failure_index}) - #{example.description.strip}",
        :failure
      )
    end

    def pad
      @pad ||= self.total_count.to_s.size
    end

    def group_progress
      "[#{' ' * pad()} #{self.total_count}]"
    end

    def example_progress
      @pad ||= self.total_count.to_s.size
      "[#{self.current_example_index.to_s.rjust(pad(), '0')}/#{self.total_count}]"
    end

    def next_failure_index
      @next_failure_index ||= 0
      @next_failure_index  += 1
    end

    def current_indentation(offset = 0)
      '  ' * (self.group_level + offset)
    end

end
