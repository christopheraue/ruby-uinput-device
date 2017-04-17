#!/usr/bin/env ruby

require_relative 'lib/uinput/device'

device = Uinput::Device.new do
  add_key(:KEY_A)
  add_event(:EV_KEY)
  add_event(:EV_SYN)
end

puts "set up: #{device.name}"

input = File.open device.dev_path

# key down
device.send_event(:EV_KEY, :KEY_A, 1)
device.send_event(:EV_SYN, :SYN_REPORT)
puts 'pressed a'

# key up
device.send_event(:EV_KEY, :KEY_A, 0)
device.send_event(:EV_SYN, :SYN_REPORT)
puts 'released a'

event1 = LinuxInput::InputEvent.new FFI::MemoryPointer.from_string input.read LinuxInput::InputEvent.size
event2 = LinuxInput::InputEvent.new FFI::MemoryPointer.from_string input.read LinuxInput::InputEvent.size
event3 = LinuxInput::InputEvent.new FFI::MemoryPointer.from_string input.read LinuxInput::InputEvent.size
event4 = LinuxInput::InputEvent.new FFI::MemoryPointer.from_string input.read LinuxInput::InputEvent.size
p event1.values
p event2.values
p event3.values
p event4.values

device.destroy