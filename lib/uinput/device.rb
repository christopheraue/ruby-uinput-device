require "uinput/device/version"

module Uinput
  class Device
    def self.create(device = '/dev/uinput', &block)
      fd = self.class::Factory.new(device, &block).create
      new fd unless fd.nil?
    end

    def initialize(fd)
      @fd = fd
    end

    def destroy
      @fd.ioctl(UI_DEV_DESTROY)
      @fd = nil
    end

    def active?
      not @fd.nil?
    end
  end
end
