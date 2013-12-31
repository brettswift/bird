require 'spec_helper'
require 'bird/cli'


describe Bird::CLI do
  before do
    FakeFS.activate!
    FakeFS::FileSystem.clear
  end
  after do
    FakeFS.deactivate!
    FakeFS::FileSystem.clear
  end

end