require 'fcntl'

module Uinput
  class Device
    class Initializer
      def initialize(device, &block)
        @file = Uinput.open_file(Fcntl::O_RDWR | Fcntl::O_NONBLOCK)

        if Uinput.version == 5
          @device = UinputSetup.new
        else
          @device = UinputUserDev.new
        end

        self.name = "Virtual Ruby Device"
        self.type = LinuxInput::BUS_VIRTUAL
        self.vendor = 0
        self.product = 0
        self.version = 0

        instance_exec &block if block

        if Uinput.version >= 5
          @file.ioctl UI_DEV_SETUP, @device.pointer.read_bytes(@device.size)
        else
          @file.syswrite @device.pointer.read_bytes(@device.size)
        end
      end

      def name=(name)
        @device[:name] = name[0,UINPUT_MAX_NAME_SIZE]
      end

      def type=(type)
        @device[:id][:bustype] = (type.is_a? Symbol) ? LinuxInput.const_get(type) : type
      end

      def vendor=(vendor)
        @device[:id][:vendor] = vendor
      end

      def product=(product)
        @device[:id][:product] = product
      end

      def version=(version)
        @device[:id][:version] = version
      end

      def add_key(key)
        @file.ioctl(UI_SET_KEYBIT, (key.is_a? Symbol) ? LinuxInput.const_get(key) : key)
      end
      alias_method :add_button, :add_key

      def add_event(event)
        @file.ioctl(UI_SET_EVBIT, (event.is_a? Symbol) ? LinuxInput.const_get(event) : event)
      end

      def create
        if @file.ioctl(UI_DEV_CREATE).zero?
          @file
        end
      end
    end
  end
end