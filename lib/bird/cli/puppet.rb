class Bird::Puppet < Thor


	desc "help", "display puppet help"
	# option :vhost, :required => true, :banner => " vcloud host"
	def help
		say "here is puppet help"
	end

end