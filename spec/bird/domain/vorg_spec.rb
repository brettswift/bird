require 'minitest/autorun'
require 'bird/domain/vorg'


describe Bird::Vorg do

  vorg_sample={:catalogs=>{"IDEV7129_Org_Catalog"=>"adabdf91-e495-4dbd-9d07-f309769a943a"}, :vdcs=>{"IDEV7129_VDC_CGNO"=>"5b10045c-f43c-44ec-b30f-1aa745fd2cba"}, :networks=>{"10.191.101.0-APP"=>"292f4638-a9de-4bfa-9d31-537469b81f8f", "10.191.106.128-DMZ"=>"85646098-d35a-4fa5-bd3d-7b9d412a464e", "10.191.101.128-INT"=>"f4a28b05-ff02-4112-8346-18ed530f04f9"}, :tasklists=>{nil=>"b08a7f0d-8b5d-4324-8983-4bedce66ec53"}}

  it "should create a vorg given a full hash" do
    vorg = Bird::Vorg.new('IDEV7129').from_hash(vorg_sample)

    # vorg.id.must_equal "e453c846-bf36-4bd7-9e52-255d718df601"
    vorg.name.must_equal "IDEV7129"
    vorg.vdcs.size.must_equal 1

    vorg.vdcs[0].id.must_equal "5b10045c-f43c-44ec-b30f-1aa745fd2cba"
  end
 
end
