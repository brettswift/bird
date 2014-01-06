### Connect to vCloud
### Fetch and List Organizations
{
    "IDEV7129" => "b08a7f0d-8b5d-4324-8983-4bedce66ec53"
}
{"IDEV7129"=>"b08a7f0d-8b5d-4324-8983-4bedce66ec53"}
### Fetch and Show 'IDEV7129' Organization
{
     :catalogs => {
        "IDEV7129_Org_Catalog" => "adabdf91-e495-4dbd-9d07-f309769a943a"
    },
         :vdcs => {
        "IDEV7129_VDC_CGNO" => "5b10045c-f43c-44ec-b30f-1aa745fd2cba"
    },
     :networks => {
          "10.191.101.0-APP" => "292f4638-a9de-4bfa-9d31-537469b81f8f",
        "10.191.106.128-DMZ" => "85646098-d35a-4fa5-bd3d-7b9d412a464e",
        "10.191.101.128-INT" => "f4a28b05-ff02-4112-8346-18ed530f04f9"
    },
    :tasklists => {
        nil => "b08a7f0d-8b5d-4324-8983-4bedce66ec53"
    }
}
{:catalogs=>{"IDEV7129_Org_Catalog"=>"adabdf91-e495-4dbd-9d07-f309769a943a"}, :vdcs=>{"IDEV7129_VDC_CGNO"=>"5b10045c-f43c-44ec-b30f-1aa745fd2cba"}, :networks=>{"10.191.101.0-APP"=>"292f4638-a9de-4bfa-9d31-537469b81f8f", "10.191.106.128-DMZ"=>"85646098-d35a-4fa5-bd3d-7b9d412a464e", "10.191.101.128-INT"=>"f4a28b05-ff02-4112-8346-18ed530f04f9"}, :tasklists=>{nil=>"b08a7f0d-8b5d-4324-8983-4bedce66ec53"}}
### Fetch and Show 'IDEV7129_VDC_CGNO' vDC
{
             :id => "5b10045c-f43c-44ec-b30f-1aa745fd2cba",
           :name => "IDEV7129_VDC_CGNO",
    :description => "CG-NO resources",
          :vapps => {
                  "Dev Cluster 001 002" => "2b849398-0ca1-4853-92b9-2970b65339e6",
        "vApp with customization issue" => "6e2263cc-ae71-40df-bb27-47d4a6f7da01",
               "RHEL64-IT_PE-Template4" => "ccc73055-51ab-41c7-9d5a-149d702cc784",
                          "ENC Testing" => "d4a9b17c-1751-4da2-8d7b-1caedf206b66",
                       "Database Hosts" => "d897db6a-3748-4b44-a0ed-4cd80c22584e",
                          "Dev Sandbox" => "e453c846-bf36-4bd7-9e52-255d718df601",
                  "EP_Support_Services" => "ed34bb2b-3c8a-480f-8a65-613406d5273c"
    },
       :networks => {
          "10.191.101.0-APP" => "292f4638-a9de-4bfa-9d31-537469b81f8f",
        "10.191.106.128-DMZ" => "85646098-d35a-4fa5-bd3d-7b9d412a464e",
        "10.191.101.128-INT" => "f4a28b05-ff02-4112-8346-18ed530f04f9"
    }
}
{:id=>"5b10045c-f43c-44ec-b30f-1aa745fd2cba", :name=>"IDEV7129_VDC_CGNO", :description=>"CG-NO resources", :vapps=>{"Dev Cluster 001 002"=>"2b849398-0ca1-4853-92b9-2970b65339e6", "vApp with customization issue"=>"6e2263cc-ae71-40df-bb27-47d4a6f7da01", "RHEL64-IT_PE-Template4"=>"ccc73055-51ab-41c7-9d5a-149d702cc784", "ENC Testing"=>"d4a9b17c-1751-4da2-8d7b-1caedf206b66", "Database Hosts"=>"d897db6a-3748-4b44-a0ed-4cd80c22584e", "Dev Sandbox"=>"e453c846-bf36-4bd7-9e52-255d718df601", "EP_Support_Services"=>"ed34bb2b-3c8a-480f-8a65-613406d5273c"}, :networks=>{"10.191.101.0-APP"=>"292f4638-a9de-4bfa-9d31-537469b81f8f", "10.191.106.128-DMZ"=>"85646098-d35a-4fa5-bd3d-7b9d412a464e", "10.191.101.128-INT"=>"f4a28b05-ff02-4112-8346-18ed530f04f9"}}
### Fetch and Show 'Dev Sandbox, Database Hosts
{
               :id => "e453c846-bf36-4bd7-9e52-255d718df601",
             :name => "Dev Sandbox",
      :description => "Eng RHEL Template",
           :status => "running",
               :ip => "10.191.101.118",
         :networks => [
        [0] {
             :name => "10.191.101.0-APP",
            :scope => {
                       :gateway => "10.191.101.1",
                       :netmask => "255.255.255.128",
                    :fence_mode => "bridged",
                :parent_network => "10.191.101.0-APP",
                :retain_network => "false"
            }
        }
    ],
    :vapp_snapshot => {
                 :size => "94489280512",
        :creation_date => "2014-01-02T16:52:16.227-07:00"
    },
         :vms_hash => {
        "devprovepzl101 - Mykola deploy test" => {
                       :addresses => [
                [0] "10.191.101.118"
            ],
                          :status => "running",
                              :id => "8eb169b2-7792-446d-8bcb-4ac7d324d579",
            :vapp_scoped_local_id => "1794e6cd-091d-47ad-820a-6fc0af70d8ab"
        },
                                  "Dongs box" => {
                       :addresses => [
                [0] "10.191.101.119"
            ],
                          :status => "running",
                              :id => "50dbfa33-b8bf-46f4-9b3a-2fb17350c25d",
            :vapp_scoped_local_id => "c9918b6b-e53e-49cb-a955-014009caeaca"
        },
                          "Login Test Server" => {
                       :addresses => [
                [0] "10.191.101.105"
            ],
                          :status => "running",
                              :id => "9619dbf2-7b85-4c78-9384-07995719f920",
            :vapp_scoped_local_id => "8490fd7f-0ba8-4a0e-8d94-8e81f539fbd7"
        }
    }
}
{:id=>"e453c846-bf36-4bd7-9e52-255d718df601", :name=>"Dev Sandbox", :description=>"Eng RHEL Template", :status=>"running", :ip=>"10.191.101.118", :networks=>[{:name=>"10.191.101.0-APP", :scope=>{:gateway=>"10.191.101.1", :netmask=>"255.255.255.128", :fence_mode=>"bridged", :parent_network=>"10.191.101.0-APP", :retain_network=>"false"}}], :vapp_snapshot=>{:size=>"94489280512", :creation_date=>"2014-01-02T16:52:16.227-07:00"}, :vms_hash=>{"devprovepzl101 - Mykola deploy test"=>{:addresses=>["10.191.101.118"], :status=>"running", :id=>"8eb169b2-7792-446d-8bcb-4ac7d324d579", :vapp_scoped_local_id=>"1794e6cd-091d-47ad-820a-6fc0af70d8ab"}, "Dongs box"=>{:addresses=>["10.191.101.119"], :status=>"running", :id=>"50dbfa33-b8bf-46f4-9b3a-2fb17350c25d", :vapp_scoped_local_id=>"c9918b6b-e53e-49cb-a955-014009caeaca"}, "Login Test Server"=>{:addresses=>["10.191.101.105"], :status=>"running", :id=>"9619dbf2-7b85-4c78-9384-07995719f920", :vapp_scoped_local_id=>"8490fd7f-0ba8-4a0e-8d94-8e81f539fbd7"}}}
### Fetch and Show VM
{
                      :id => "9619dbf2-7b85-4c78-9384-07995719f920",
                 :vm_name => "Login Test Server",
                 :os_desc => "Red Hat Enterprise Linux 6 (64-bit)",
                :networks => {
        "10.191.101.0-APP" => {
                         :index => "0",
                            :ip => "10.191.101.105",
                   :external_ip => nil,
                  :is_connected => "true",
                   :mac_address => "00:50:56:02:00:dc",
            :ip_allocation_mode => "MANUAL"
        }
    },
    :guest_customizations => {
                      :enabled => "true",
         :admin_passwd_enabled => "true",
            :admin_passwd_auto => "false",
                 :admin_passwd => "Welcome0",
        :reset_passwd_required => "false",
                :computer_name => "devprovepzl005"
    },
                  :status => "running"
}
{:id=>"9619dbf2-7b85-4c78-9384-07995719f920", :vm_name=>"Login Test Server", :os_desc=>"Red Hat Enterprise Linux 6 (64-bit)", :networks=>{"10.191.101.0-APP"=>{:index=>"0", :ip=>"10.191.101.105", :external_ip=>nil, :is_connected=>"true", :mac_address=>"00:50:56:02:00:dc", :ip_allocation_mode=>"MANUAL"}}, :guest_customizations=>{:enabled=>"true", :admin_passwd_enabled=>"true", :admin_passwd_auto=>"false", :admin_passwd=>"Welcome0", :reset_passwd_required=>"false", :computer_name=>"devprovepzl005"}, :status=>"running"}