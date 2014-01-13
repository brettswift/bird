require "bundler/gem_tasks"
require 'rake/testtask'
require 'colorize'

Rake::TestTask.new do |t|
  t.libs << "spec"
  t.pattern = "spec/**/*_spec.rb"
end



task :default => [:install]


desc "continuous testing"
task "runBird"  do
  sh %Q{clear}

  # puts "\nbird test".white
  # sh %Q{bundle exec ./bin/bird cloud ips} do |ok, res|
  #   if ! ok
  #     puts "failed to run bird cloud ips"
  #   end
  # end

  # puts "\nbird help".white
  # sh %Q{bundle exec ./bin/bird help} do |ok, res|
  #   if ! ok
  #     puts "failed to run bird help"
  #   end
  # end

  # puts "\nbird help cloud".white
  # sh %Q{bundle exec ./bin/bird help cloud} do |ok, res|
  #   if ! ok
  #     puts "failed to run bird help cloud"
  #   end
  # end

  puts "\n bird setup:".white
  sh %Q{./bird setup} 
  puts "\n bird setup override --vorg test_org_name --host vcloud.host.name --user  test_user --pass  azBHehbD2EibMuxGZPqIVQ==".white
  sh %Q{./bird setup override --org_name test_org_name --host vcloud.host.name --user  test_user --pass  donkeyPass} 

  puts "\ntests".white
  sh %Q{bundle exec rake test} do |ok, res|
    if ! ok
      puts "failed to run bundle exec rake test"
    end
  end
end


desc "Install Gems"
task "bundle:install"  do
  sh %Q{bundle install --standalone --clean} do |ok, res|
    if ! ok
      puts "fail to install gems (status = #{res.exitstatus})"
    end
  end
end

desc "Update Gems"
task "bundle:update" do
  sh %Q{bundle update && bundle install --standalone --clean} do |ok, res|
    if ! ok
      puts "fail to update gems (status = #{res.exitstatus})"
    end
  end
end

desc "Generate Doc"
task :doc do
  sh %Q{pandoc -f markdown -o "README.pdf" README.md}
end