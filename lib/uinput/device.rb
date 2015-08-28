require 'bundler/setup'
require 'uinput'
require_relative "device/version"
require_relative "device/system_initializer"
require_relative "device/error"

module Uinput
  class Device
    def initialize(&block)
      @file = self.class::SystemInitializer.new(self, &block).create
    end

    def destroy
      @file.ioctl(UI_DEV_DESTROY, nil)
      @file = nil
    end

    def active?
      not @file.nil?
    end

    def send_event(type, code, value = 0)
      event = LinuxInput::InputEvent.new
      event[:time] = LinuxInput::Timeval.new
      event[:time][:tv_sec] = Time.now.to_i
      event[:type] = type.is_a?(Symbol) ? LinuxInput.const_get(type) : type
      event[:code] = code.is_a?(Symbol) ? LinuxInput.const_get(code) : code
      event[:value] = value
      @file.syswrite(event.pointer.read_bytes(event.size))
    end
  end
end
