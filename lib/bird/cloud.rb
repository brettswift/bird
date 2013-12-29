require 'thor'
require 'bird'
require 'user_config'
require 'vcloud-rest/connection'


class Bird::Cloud < Thor

  default_task :list

  # Hack to override the help message produced by Thor.
  # With PR $387 this causes unexpected behaviour
  # https://github.com/wycats/thor/issues/261#issuecomment-16880836
  # def self.banner(command, namespace = nil, subcommand = 'list')
  #   "#{basename} list #{command.usage}"
  # end


  desc "list", "[--vapp] list restricted to: vApp <name> - NOT IMPLEMENTED"
  option :vapp, :banner => " vApp name"
  option :vm, :banner => " vm name"
  def list
    say("Sorry buddy, I haven't been imlplemented yet.",:red)
  end

  desc "search", "<name> - NOT IMPLEMENTED"
  option :vapp, :banner => " vApp name"
  option :vm, :banner => " vm name"
  def search(name)
    say("Sorry buddy, I haven't been imlplemented yet.",:red)
  end

  desc "snapshot", "[--vm] snapshot something - NOT IMPLEMENTED"
  def snapshot
    say("Sorry buddy, I haven't been imlplemented yet.",:red)
  end

  desc "restore", "[--vm] restore something - NOT IMPLEMENTED"
  def restore
    say("Sorry buddy, I haven't been imlplemented yet.",:red)
  end

  desc "deploy", "[--vm] deploy something - NOT IMPLEMENTED"
  def deploy
    say("Sorry buddy, I haven't been imlplemented yet.",:red)
  end

  private

  def get_vcd
    host = config[:vcloud][:host]
    user = config[:vcloud][:user]
    pass = config[:vcloud][:pass]
    org = config[:vcloud][:org]
    api = "1.5"

    connection = VCloudClient::Connection.new(host, user, pass, org, api)
    connection.login

    ### Fetch a list of the organizations you have access to

    puts "### Fetch and List Organizations"
    orgs = connection.get_organizations
    ap orgs

    # ### Fetch and show an organization, COE is an example, you should replace it with your own organization

    puts "### Fetch and Show 'IDEV7129' Organization"
    org = connection.get_organization(orgs["IDEV7129"])
    ap org

    # ### Fetch and show a vDC, OvDC-PAYG-Bronze-01 is an example, you should replace it with your own vDC

    puts "### Fetch and Show 'IDEV7129_VDC_CGNO' vDC"
    vdc = connection.get_vdc(org[:vdcs]["IDEV7129_VDC_CGNO"])
    ap vdc
  end

  # def login


  #   @connection = VCloudClient::Connection.new(host, user, pass, org, api)
  #   @connection.login
  # end

  # def logout
  #   @connection.logout
  # end

end


# host = 'https://vcd011no.lab.vim.dcs.mlb.inet'
# user = 'bswift'
# pass = 'asdfasdf'
# org  = 'IDEV7129'
# api  = '5.1'

# puts "#################################################################"
# puts "# vcloud-rest example"
# puts "#"
# puts "### Connect to vCloud"

# ### Connect to vCloud

# connection = VCloudClient::Connection.new(host, user, pass, org, api)
# connection.login

# ### Fetch a list of the organizations you have access to

# puts "### Fetch and List Organizations"
# orgs = connection.get_organizations
# ap orgs

# # ### Fetch and show an organization, COE is an example, you should replace it with your own organization

# puts "### Fetch and Show 'IDEV7129' Organization"
# org = connection.get_organization(orgs["IDEV7129"])
# ap org

# # ### Fetch and show a vDC, OvDC-PAYG-Bronze-01 is an example, you should replace it with your own vDC

# puts "### Fetch and Show 'IDEV7129_VDC_CGNO' vDC"
# vdc = connection.get_vdc(org[:vdcs]["IDEV7129_VDC_CGNO"])
# ap vdc

# # ### Fetch and show a vApp, Dev Sandbox is an example, you should replace it with your own vDC

# puts "### Fetch and Show 'Dev Sandbox, Database Hosts"
# vApp = connection.get_vapp(vdc[:vapps]["Dev Sandbox"])
# ap vApp
