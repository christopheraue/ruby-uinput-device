require 'spec_helper'

describe Uinput::Device do
  it 'has a version number' do
    expect(Uinput::Device::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
