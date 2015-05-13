require_relative 'device'
require_relative 'keyboard/factory'

module UInput
  class Keyboard < Device
    def press(keys)
      keys.split('+').each do |key|
        send_key_event(key, state: 1)
      end
      send_syn_event
    end

    def release(keys)
      keys.split('+').each do |key|
        send_key_event(key, state: 0)
      end
      send_syn_event
    end

    def tap(keys)
      press(keys)
      release(keys)
    end

    private

    MAP = {
      ctrl: :leftctrl,
      shift: :leftshift,
      alt: :leftalt
    }

    def map(key)
      MAP[key.downcase.to_sym] || key
    end
  end
end
