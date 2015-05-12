require_relative 'device'

module Uinput
  class Keyboard < Device
    def press(key)
      event = InputEvent.new
      event[:time] = nil
      event[:type] = EV_KEY
      event[:code] = const_get("KEY_#{key.upcase}")
      event[:value] = 1
      @fd.write(event)
    end

    def release(key)
      event = InputEvent.new
      event[:time] = nil
      event[:type] = EV_KEY
      event[:code] = const_get("KEY_#{key.upcase}")
      event[:value] = 0
      @fd.write(event)
    end

    def tap(key)
      press(key)
      release(key)
    end

    def combo(keys)
      keys = keys.split('+')
      keys.each{ |key| press(key) }
      keys.each{ |key| release(key) }
    end

    private

    MAP = {
      ctrl: :leftctrl,
      shift: :leftshift,
      alt: :leftalt
    }

    def map(key)
      MAP[key.downcase.to_sym]
    end
  end
end
