require 'minitest/autorun'
require 'bird/domain/vapp'


describe Bird::Vapp do

  vapp_sample={:id=>"e453c846-bf36-4bd7-9e52-255d718df601", :name=>"Dev Sandbox", :description=>"Eng RHEL Template", :status=>"running", :ip=>"10.191.101.118", :networks=>[{:name=>"10.191.101.0-APP", :scope=>{:gateway=>"10.191.101.1", :netmask=>"255.255.255.128", :fence_mode=>"bridged", :parent_network=>"10.191.101.0-APP", :retain_network=>"false"}}], :vapp_snapshot=>{:size=>"94489280512", :creation_date=>"2014-01-02T16:52:16.227-07:00"}, :vms_hash=>{"devprovepzl101 - Mykola deploy test"=>{:addresses=>["10.191.101.118"], :status=>"running", :id=>"8eb169b2-7792-446d-8bcb-4ac7d324d579", :vapp_scoped_local_id=>"1794e6cd-091d-47ad-820a-6fc0af70d8ab"}, "Dongs box"=>{:addresses=>["10.191.101.119"], :status=>"running", :id=>"50dbfa33-b8bf-46f4-9b3a-2fb17350c25d", :vapp_scoped_local_id=>"c9918b6b-e53e-49cb-a955-014009caeaca"}, "Login Test Server"=>{:addresses=>["10.191.101.105"], :status=>"running", :id=>"9619dbf2-7b85-4c78-9384-07995719f920", :vapp_scoped_local_id=>"8490fd7f-0ba8-4a0e-8d94-8e81f539fbd7"}}}

  it "should create a app given json input" do
    vapp = Bird::Vapp.new.fromHash(vapp_sample)

    vapp.id.must_equal "e453c846-bf36-4bd7-9e52-255d718df601"
    vapp.name.must_equal "Dev Sandbox"
    vapp.status.must_equal "running"
    vapp.vms.size.must_equal 3
    vapp.snapshotDate.must_equal "2014-01-02T16:52:16.227-07:00"

    vapp.vms[0].ips.must_include "10.191.101.118"
    vapp.vms[0].friendlyName.must_equal "devprovepzl101 - Mykola deploy test"
    # vapp.vms[0].machineName.must_equal "devprovepzl101"

  end
 
end
