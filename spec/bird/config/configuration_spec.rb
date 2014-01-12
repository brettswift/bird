require 'minitest/autorun'
require 'user_config'
require 'bird/config/configuration'
require 'spec_helper'

describe Bird::Configuration do

    before do
        FakeFS.activate!
        FakeFS::FileSystem.clear
    end
    after do
        FakeFS.deactivate!
        FakeFS::FileSystem.clear
    end

    it "should report valid config when minimum parameters exist" do
        config = Bird::Configuration.new
        config.host = "sample_host"
        config.org_name = "sample_org_name"
        config.user = "sample_user"
        config.pass = "sample_pass"
        config.has_minimal_configuration?.must_equal true

        config.host = nil
        config.has_minimal_configuration?.must_equal false
    end

    it "should encrypt password" do
        config = Bird::Configuration.new
        config.pass = "donkey_password"
        encrypted_password = "7efFVJfeN1CJ0fmp2+PDcA=="
        #encrypted password will have a return line at the end
        config.pass_encrypted.start_with?(encrypted_password).must_equal true
    end

    it "should  decrypt password" do
        config = Bird::Configuration.new
        encrypted_password = "yao29kmbaJtjHYcEkrwnAw=="
        config.pass_encrypted = encrypted_password
        config.pass.must_equal "goat_password"
    end


    describe "given complete configuration" do
        attr_accessor :uc
        before do
            @uc = UserConfig.new(".bird")['conf.yaml']
            @uc[:vcloud] = {}
            @uc[:vcloud][:host] = "test_host"
            @uc[:vcloud][:org_name] = "test_org"
            @uc[:vcloud][:user] = "test_user"
            @uc[:vcloud][:pass_encrypted] = "7efFVJfeN1CJ0fmp2+PDcA=="
            @uc.save
        end
        it "should load valid configuration" do 
            @conf = Bird::Configuration.new
            @conf.has_minimal_configuration?.must_equal true
            @conf.host.must_equal "test_host"
        end

        it "should save valid configuration" do 
            @conf = Bird::Configuration.new
            @conf.curr_vapp_id = "12341234"
            @conf.save
            @conf = nil
            @conf = Bird::Configuration.new
            @conf.curr_vapp_id.must_equal "12341234"
        end

        it "should load partial configuration without error" do 
            @uc[:vcloud][:host] = nil
            @uc.save
            @conf = Bird::Configuration.new
            @conf.has_minimal_configuration?.must_equal false
            @conf.host.must_equal nil
        end

        it "should report configuration incomplete when in console mode" do 
            @conf = Bird::Configuration.new(true)
            @conf.has_minimal_configuration?.must_equal false
        end


        

    end





end
