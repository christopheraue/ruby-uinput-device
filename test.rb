$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'uinput/keyboard'

begin
  keyboard = Uinput::Keyboard.create
  keyboard.combo('ctrl+d')
ensure
  keyboard.destroy
end