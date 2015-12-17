require 'bundler/setup'
require 'uinput'
require_relative "device/version"
require_relative "device/system_initializer"
require_relative "device/error"

module Uinput
  class Device
    SYS_INPUT_DIR = '/sys/devices/virtual/input/'

    def initialize(&block)
      @file = self.class::SystemInitializer.new(self, &block).create
    end

    def destroy
      @file.ioctl(UI_DEV_DESTROY, nil)
      @file = nil
    end

    def sysname
      @sysname ||= begin
        name_len = 128
        name_buffer = [' ' * name_len].pack("A#{name_len}")
        @file.ioctl(Uinput.UI_GET_SYSNAME(name_len), name_buffer)
        name_buffer.unpack("A#{name_len}").first
      end
    end

    def sys_path
      "#{SYS_INPUT_DIR}#{sysname}"
    end

    def dev_path
      event_dir = Dir["#{sys_path}/event*"].first
      event = File.basename(event_dir)
      "/dev/input/#{event}"
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
