require 'uinput'
require_relative "device/version"
require_relative "device/factory"

module UInput
  class Device
    class << self
      def create(device = '/dev/uinput', &block)
        file = self::Factory.new(device, &block).create
        new file unless file.nil?
      end
    end

    def initialize(file)
      @file = file
    end

    def destroy
      @file.ioctl(UI_DEV_DESTROY, nil)
      @file = nil
    end

    def active?
      not @file.nil?
    end

    def send_event(type, code, value = 0)
      event = InputEvent.new
      FFI::LibC.gettimeofday(event[:time], nil)
      event[:type] = type
      event[:code] = code
      event[:value] = value
      @file.syswrite(event.pointer.read_bytes(event.size))
    end

    def send_syn_event
      send_event(EV_SYN, SYN_REPORT)
    end
  end
end
