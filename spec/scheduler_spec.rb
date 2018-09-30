# frozen_string_literal: true

require_relative 'helper'
require 'scheduler'

describe Scheduler do
  let :scheduler do
    Scheduler.new
  end

  after do
    Process.kill('TERM', scheduler.pid) if scheduler.pid
  end

  it 'forks a scheduler' do
    scheduler.start
    Process.getpgid(scheduler.pid) # won't raise Errno::ESRCH
  end
end
