module UInput
  class Keyboard < Device
    class Factory < Device::Factory
      def initialize(*args, &block)
        super
        receive_key_events
        add_all_keys
      end

      def add_all_keys
        (0..KEY_MAX).each{ |key| add_key(key) }
      end
    end
  end
end