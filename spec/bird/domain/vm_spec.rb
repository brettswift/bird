require 'spec_helper'
require 'bird/domain/vm'


describe Bird::Vm do

  vm_sample_from_vapp=["devprovepzl100 - Ad-hoc Sandbox", {:addresses=>["10.191.101.119"], :status=>"running", :id=>"867e5e4e-389b-42d5-a2ec-da229856f90a", :vapp_scoped_local_id=>"4b2f88ec-6a71-49ff-9825-bf5bef7f11b3"}]


  vm_sample_full={:id=>"9619dbf2-7b85-4c78-9384-07995719f920", :vm_name=>"Login Test Server", :os_desc=>"Red Hat Enterprise Linux 6 (64-bit)", :networks=>{"10.191.101.0-APP"=>{:index=>"0", :ip=>"10.191.101.105", :external_ip=>nil, :is_connected=>"true", :mac_address=>"00:50:56:02:00:dc", :ip_allocation_mode=>"MANUAL"}}, :guest_customizations=>{:enabled=>"true", :admin_passwd_enabled=>"true", :admin_passwd_auto=>"false", :admin_passwd=>"Welcome0", :reset_passwd_required=>"false", :computer_name=>"devprovepzl005"}, :status=>"running"}

  it "should create a vm given array from vapp summary" do

    vm = Bird::Vm.new.fromVappSummary(vm_sample_from_vapp)
    
    vm.friendlyName.must_equal "devprovepzl100 - Ad-hoc Sandbox"
    vm.id.must_equal "867e5e4e-389b-42d5-a2ec-da229856f90a"
    vm.status.must_equal "running"
    vm.ips.size.must_equal 1
  end


  it "should create a vm given full response from API" do

    vm = Bird::Vm.new.fromFullHash(vm_sample_full)
    
    vm.friendlyName.must_equal "Login Test Server"
    vm.machineName.must_equal "devprovepzl005"
    vm.id.must_equal "9619dbf2-7b85-4c78-9384-07995719f920"
    vm.status.must_equal "running"
    vm.ips.size.must_equal 1
  end


end
