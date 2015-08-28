module Uinput
  class Device
    class SystemInitializer
      FILE = '/dev/uinput'

      def initialize(device, &block)
        @file = File.open(FILE, Fcntl::O_WRONLY | Fcntl::O_NDELAY)
        @device = UinputUserDev.new

        self.name = "Virtual Ruby Device"
        self.type = LinuxInput::BUS_VIRTUAL
        self.vendor = 0
        self.product = 0
        self.version = 0

        instance_exec &block if block
      end

      def name=(name)
        @device[:name] = name
      end

      def type=(type)
        @device[:id][:bustype] = type.is_a?(Symbol) ? LinuxInput.const_get(type) : type
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
        @file.ioctl(UI_SET_KEYBIT, key.is_a?(Symbol) ? LinuxInput.const_get(key) : key)
      end
      alias_method :add_button, :add_key

      def add_event(event)
        @file.ioctl(UI_SET_EVBIT, event.is_a?(Symbol) ? LinuxInput.const_get(event) : event)
      end

      def create
        @file.syswrite(@device.pointer.read_bytes(@device.size))
        @file if @file.ioctl(UI_DEV_CREATE).zero?
      end
    end
  end
end