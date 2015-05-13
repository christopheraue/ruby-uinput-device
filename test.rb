$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'bundler/setup'
require 'uinput/keyboard'

begin
  keyboard = UInput::Keyboard.create
  loop do
    keyboard.tap('d')
    sleep 1
  end
ensure
  keyboard.destroy if keyboard
end