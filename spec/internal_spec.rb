require 'spec_helper'

RSpec.describe Doggo do
  before :each do
    @bork = StringIO.new
    @dog  = Doggo.new(@bork)
  end

  context '#start' do
    before :each do
      @notification = double('Notification', count: 4)
    end

    it 'sets total count from notification' do
      expect(@dog.total_count).to eql(0)
      @dog.start(@notification)
      expect(@dog.total_count).to eql(@notification.count)
      @dog.start(@notification)
      expect(@dog.total_count).to eql(@notification.count) # I.e. it was set, not incremented
    end
  end # "context '#start' do"

  context 'individual examples' do
    before :each do
      @notification        = double('Notification', count: 4)
      @example_description = 'Example description'
      @pending_message     = 'Custom pending message'
      @example             = double(
        'Example',
        description: @example_description,
        execution_result: double(
          'Execution result',
          pending_message: @pending_message
        )
      )
    end

    context '#example_started' do
      it 'notes an example is running' do
        expect(@dog.example_running).to eq(false)
        @dog.example_started(@notification)
        expect(@dog.example_running).to eq(true)
      end

      it 'increments the example index' do
        expect(@dog.current_example_index).to eql(0)
        @dog.example_started(@notification)
        expect(@dog.current_example_index).to eql(1)
        @dog.example_started(@notification)
        expect(@dog.current_example_index).to eql(2)
      end
    end # "context '#example_started' do"

    context '#example_passed' do
      before :each do
        @dog.start(@notification)
        @passed = double('Passing test', example: @example)
      end

      it 'notes an example is no longer running' do
        expect(@dog.example_running).to eq(false)

        @dog.example_started(@notification)
        expect(@dog.example_running).to eq(true)

        @dog.example_passed(@passed)
        expect(@dog.example_running).to eq(false)
      end

      it 'increments the "passed" count' do
        expect(@dog.passed_count).to eql(0)

        @dog.example_started(@notification)
        @dog.example_passed(@passed)
        expect(@dog.passed_count).to eql(1)

        @dog.example_started(@notification)
        @dog.example_passed(@passed)
        expect(@dog.passed_count).to eql(2)
      end

      it 'logs the success' do
        @dog.example_started(@notification)
        @dog.example_passed(@passed)

        expect(@bork.string).to include("[1/#{@notification.count}]")
        expect(@bork.string).to include(@example_description)
      end
    end # "context '#example_passed' do"

    context '#example_failed' do
      before :each do
        @dog.start(@notification)
        @failed = double('Failing test', example: @example)
      end

      it 'notes an example is no longer running' do
        expect(@dog.example_running).to eq(false)

        @dog.example_started(@notification)
        expect(@dog.example_running).to eq(true)

        @dog.example_failed(@failed)
        expect(@dog.example_running).to eq(false)
      end

      it 'increments the "failed" count' do
        expect(@dog.failed_count).to eql(0)

        @dog.example_started(@notification)
        @dog.example_failed(@failed)
        expect(@dog.failed_count).to eql(1)

        @dog.example_started(@notification)
        @dog.example_failed(@failed)
        expect(@dog.failed_count).to eql(2)
      end

      it 'logs the failure' do
        @dog.example_started(@notification)
        @dog.example_failed(@failed)

        expect(@bork.string).to include("[1/#{@notification.count}]")
        expect(@bork.string).to include('FAILED')
        expect(@bork.string).to include(@example_description)
      end
    end # "context '#example_failed' do"

    context '#example_pending' do
      before :each do
        @dog.start(@notification)
        @pending = double('Pending test', example: @example)
      end

      it 'notes an example is no longer running' do
        expect(@dog.example_running).to eq(false)

        @dog.example_started(@notification)
        expect(@dog.example_running).to eq(true)

        @dog.example_pending(@pending)
        expect(@dog.example_running).to eq(false)
      end

      it 'increments the "pending" count' do
        expect(@dog.pending_count).to eql(0)

        @dog.example_started(@notification)
        @dog.example_pending(@pending)
        expect(@dog.pending_count).to eql(1)

        @dog.example_started(@notification)
        @dog.example_pending(@pending)
        expect(@dog.pending_count).to eql(2)
      end

      it 'logs the custom message' do
        @dog.example_started(@notification)
        @dog.example_pending(@pending)

        expect(@bork.string).to include("[1/#{@notification.count}]")
        expect(@bork.string).to include('PENDING')
        expect(@bork.string).to include(@pending_message)
        expect(@bork.string).to include(@example_description)
      end
    end # "context '#example_pending' do"
  end   # "context 'individual examples' do"

  context 'example groups' do
    before :each do
      @group_description  = 'Group description'
      @group_notification = double(
        'Group notification',
        group: double(
          'RSpec group',
          description: @group_description
        )
      )
    end

    context '#example_group_started' do
      it 'increments group level' do
        expect(@dog.group_level).to eql(0)
        @dog.example_group_started(@group_notification)
        expect(@dog.group_level).to eql(1)
        @dog.example_group_started(@group_notification)
        expect(@dog.group_level).to eql(2)
      end

      it 'outputs an indication of group progress' do
        @dog.example_group_started(@group_notification)
        expect(@bork.string).to include(@group_description)
      end

      it 'outputs a separator at top level' do
        @dog.example_group_started(@group_notification)
        expect(@bork.string).to start_with("\n")
      end

      it 'does not output a separator below top level' do
        @dog.example_group_started(@group_notification)
        expect(@bork.string).to start_with("\n")
        @bork.truncate(0)

        @dog.example_group_started(@group_notification)
        expect(@bork.string).to_not start_with("\n")
      end
    end # "context '#example_group_started' do"

    context '#example_group_finished' do
      it 'derements group level' do
        @dog.example_group_started(@group_notification)
        @dog.example_group_started(@group_notification)
        expect(@dog.group_level).to eql(2)
        @dog.example_group_finished(@group_notification)
        expect(@dog.group_level).to eql(1)
        @dog.example_group_finished(@group_notification)
        expect(@dog.group_level).to eql(0)
      end

      it 'does not decrement below zero' do
        expect(@dog.group_level).to eql(0)
        @dog.example_group_finished(@group_notification)
        expect(@dog.group_level).to eql(0)
      end
    end # "context '#example_group_finished' do"
  end   # "context 'example groups' do"

  context '#message' do
    before :each do
      @message              = 'A message'
      @message_notification = double(
        'Message notification',
        message: @message
      )
    end

    it 'logs directly with no example running' do
      @dog.message(@message_notification)
      expect(@bork.string.strip).to eql(@message)
    end

    it 'logs directly if an example-start occurs unexpectedly' do
      notification = double('Notification', count: 4)
      @dog.example_started(notification)
      @dog.message(@message_notification)
      @dog.send(:flush_messages)
      expect(@bork.string.strip).to eql(@message)
    end

    it 'logs in context if an example is running' do
      notification = double('Notification', count: 4)
      @dog.start(notification)
      @dog.example_started(notification)
      @dog.message(@message_notification)
      @dog.send(:flush_messages)
      expect(@bork.string.strip).to start_with('[')
      expect(@bork.string.strip).to end_with(@message)
    end
  end
end