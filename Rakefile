require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "spec"
  t.pattern = "spec/**/*_spec.rb"
end



task :default => [:install]

  # desc "full uninstall and redeploy"
  # task :redeploy => [:uninstall, :build, :install] do
  #   puts "Complete redeploy at: #{Time.now}"
  # end

  # desc "Uninstall Bird"
  # task :uninstall do
  #   sh %Q{gem uninstall bird -xq} #do |ok, res|
  #   #   if ! ok
  #   #     puts "#######"
  #   #     puts res
  #   #     puts "#######"
  #   #     puts "fail to uninstall bird (status = #{res.exitstatus})"
  #   #   else
  #   #     puts "uninstalled bird"
  #   #   end
  #   # end
  # end
 

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