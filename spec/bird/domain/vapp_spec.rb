require 'spec_helper'
require 'bird/domain/vapp'


describe Bird::Vapp do

  vapp_sample={:id=>"e453c846-bf36-4bd7-9e52-255d718df601",
   :name=>"Dev Sandbox",
   :description=>"Eng RHEL Template",
   :status=>"running",
   :ip=>"10.191.101.119",
   :networks=>[{:name=>"10.191.101.0-APP",
   :scope=>{:gateway=>"10.191.101.1",
   :netmask=>"255.255.255.128",
   :fence_mode=>"bridged",
   :parent_network=>"10.191.101.0-APP",
   :retain_network=>"false"}  }  ],
   :vapp_snapshot=>{:size=>"47244640256",
   :creation_date=>"2013-12-24T09:18:25.617-07:00"}  ,
   :vms_hash=>{"devprovepzl100 - Ad-hoc Sandbox for Dong"=>{:addresses=>["10.191.101.119"],
   :status=>"running",
   :id=>"867e5e4e-389b-42d5-a2ec-da229856f90a",
   :vapp_scoped_local_id=>"4b2f88ec-6a71-49ff-9825-bf5bef7f11b3"}  ,
   "devprovepzl101 - Mykola deploy test"=>{:addresses=>["10.191.101.118"],
   :status=>"running",
   :id=>"8eb169b2-7792-446d-8bcb-4ac7d324d579",
   :vapp_scoped_local_id=>"1794e6cd-091d-47ad-820a-6fc0af70d8ab"}  }  }  

  it "should create a app given json input" do


    # vapp_json = IO.read("./spec/bird/domain/samples/vapp.json")

    # puts vapp_json[:vms_hash]
    # puts vapp_sample[:id]
    vapp = Bird::Vapp.new(vapp_sample)

    
    vapp.id.must_equal "e453c846-bf36-4bd7-9e52-255d718df601"
    vapp.vms.size.must_equal 2


  end



end
