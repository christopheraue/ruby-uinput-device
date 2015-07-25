module Uinput
  class Device
    class Factory
      def initialize(device, &block)
        @file = File.open(device, Fcntl::O_WRONLY | Fcntl::O_NDELAY)
        @device = UinputUserDev.new

        self.name = "Virtual Ruby Device"
        self.type = BUS_VIRTUAL
        self.vendor = 0
        self.product = 0
        self.version = 0

        receive_syn_events

        instance_exec &block if block
      end

      def name=(name)
        @device[:name] = name
      end

      def type=(type)
        @device[:id][:bustype] = type
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
        @file.ioctl(UI_SET_KEYBIT, key)
      end
      alias_method :add_button, :add_key

      def add_event(event)
        @file.ioctl(UI_SET_EVBIT, event)
      end

      def receive_key_events
        add_event(EV_KEY)
      end

      def receive_syn_events
        add_event(EV_SYN)
      end

      def create
        @file.syswrite(@device.pointer.read_bytes(@device.size))
        if @file.ioctl(UI_DEV_CREATE).zero?
          @file
        end
      end
    end
  end
end