require 'minitest/autorun'
require 'bird/domain/vdc'


describe Bird::Vdc do

  vdc_sample={:id=>"5b10045c-f43c-44ec-b30f-1aa745fd2cba", :name=>"IDEV7129_VDC_CGNO", :description=>"CG-NO resources", :vapps=>{"Dev Cluster 001 002"=>"2b849398-0ca1-4853-92b9-2970b65339e6", "vApp with customization issue"=>"6e2263cc-ae71-40df-bb27-47d4a6f7da01", "RHEL64-IT_PE-Template4"=>"ccc73055-51ab-41c7-9d5a-149d702cc784", "ENC Testing"=>"d4a9b17c-1751-4da2-8d7b-1caedf206b66", "Database Hosts"=>"d897db6a-3748-4b44-a0ed-4cd80c22584e", "Dev Sandbox"=>"e453c846-bf36-4bd7-9e52-255d718df601", "EP_Support_Services"=>"ed34bb2b-3c8a-480f-8a65-613406d5273c"}, :networks=>{"10.191.101.0-APP"=>"292f4638-a9de-4bfa-9d31-537469b81f8f", "10.191.106.128-DMZ"=>"85646098-d35a-4fa5-bd3d-7b9d412a464e", "10.191.101.128-INT"=>"f4a28b05-ff02-4112-8346-18ed530f04f9"}}

  it "should create a vdc given a ruby hash" do
    vdc = Bird::Vdc.new.fromHash(vdc_sample)

    vdc.id.must_equal "5b10045c-f43c-44ec-b30f-1aa745fd2cba"
    vdc.name.must_equal "IDEV7129_VDC_CGNO"
    vdc.vapps.size.must_equal 7

    vdc.vapps[0].isSummary.must_equal true
    vdc.vapps[0].name.must_equal "Dev Cluster 001 002"
    vdc.vapps[0].id.must_equal "2b849398-0ca1-4853-92b9-2970b65339e6"

    # vapp.vms[0].ips.must_include "10.191.101.118"
    # vapp.vms[0].friendlyName.must_equal "devprovepzl101 - Mykola deploy test"
    # vapp.vms[0].machineName.must_equal "devprovepzl101"

  end
 
end
