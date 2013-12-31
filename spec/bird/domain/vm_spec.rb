require 'spec_helper'
require 'bird/domain/vm'


describe Bird::Vm do

  vm_sample=["devprovepzl100 - Ad-hoc Sandbox", {:addresses=>["10.191.101.119"], :status=>"running", :id=>"867e5e4e-389b-42d5-a2ec-da229856f90a", :vapp_scoped_local_id=>"4b2f88ec-6a71-49ff-9825-bf5bef7f11b3"}]

  it "should create a vm given json input" do

    # puts vm_sample[0]
    # puts vapp_sample[:id]
    vm = Bird::Vm.new(vm_sample)

    
    vm.name.must_equal "devprovepzl100 - Ad-hoc Sandbox"
    vm.id.must_equal "867e5e4e-389b-42d5-a2ec-da229856f90a"
    vm.status.must_equal "running"
    vm.ips.size.must_equal 1


  end



end
