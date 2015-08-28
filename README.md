# Uinput::Device

Generic ruby wrapper around uinput to create devices.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uinput-device'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uinput-device

## Usage

```ruby
require 'uinput/device'
```

Initializing a new virtual device having an A key:

```ruby
device = Uinput::Device.new do
    self.name = "Our virtual device"
    self.type = LinuxInput::BUS_VIRTUAL
    self.add_key(:KEY_A)
    self.add_event(:EV_KEY)
    self.add_event(:EV_SYN)
end
```

Symbols like `:KEY_A` are mapped to constants in the `LinuxInput` namespace (see
[linux_input](https://github.com/christopheraue/ruby-linux_input))

Typing an 'a' on our keyboard:

```ruby
# key down
device.send_event(:EV_KEY, :KEY_A, 1)
device.send_event(:EV_SYN, :SYN_REPORT)

# key up
device.send_event(:EV_KEY, :KEY_A, 0)
device.send_event(:EV_SYN, :SYN_REPORT)
```

Destroying the device:

```ruby
device.destroy
```