require 'thor'
require 'bird'
require 'user_config'
require 'vcloud-rest/connection'


class Bird::Cloud < Thor

  default_task :list

  # Hack to override the help message produced by Thor.
  # https://github.com/wycats/thor/issues/261#issuecomment-16880836
  def self.banner(command, namespace = nil, subcommand = 'list')
    "#{basename} list #{command.usage}"
  end

  desc "list", "list vApps - NOT IMPLEMENTED"
  option :vapp, :banner => " vApp name"
  def list
    #TODO: implement me
  end

  desc "snapshot", "snapshot something - NOT IMPLEMENTED"
  def snapshot
    #TODO: implement me
  end

  desc "restore", "restore something - NOT IMPLEMENTED"
  def restore
    #TODO: implement me
  end

  desc "deploy", "deploy something - NOT IMPLEMENTED"
  def deploy
    #TODO: implement me
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
# pass = 'Pa55w0rd987'
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
