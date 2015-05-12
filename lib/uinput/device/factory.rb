require_relative '../device'

module Uinput
  class Device
    class Factory
      def initialize(device, &block)
        @fd = IO.sysopen(device, Fcntl::O_WRONLY | Fcntl::O_NDELAY)
        if @fd.nil?
          raise "Uinput device #{device} does not exist."
        end
        @device = UinputUserDev.new

        self.name = "Virtual Ruby Device"
        self.type = BUS_VIRTUAL
        self.vendor = 0
        self.product = 0
        self.version = 0

        instance_exec &block if block
      end

      def type=(type)
        @device[:id][:bustype] = type
      end

      def name=(name)
        @device[:name] = name
      end

      def vendor=(vendor)
        @device[:vendor] = vendor
      end

      def product=(product)
        @device[:product] = product
      end

      def version=(version)
        @device[:version] = version
      end

      def add_key(key)
        @fd.ioctl(UI_SET_KEYBIT, key)
      end
      alias_method :add_button, :add_key

      def add_event(event)
        @fd.ioctl(UI_SET_EVBIT, event)
      end

      def receive_key_events
        add_event(EV_KEY)
      end

      def create
        @fd.write(@device)
        if @fd.ioctl(UI_DEV_CREATE).zero?
          @fd
        end
      end
    end
  end
end