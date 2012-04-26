module ESearchy
	module DB
		def self.start
			Display.msg "Starting MongoDB"
			mongod = File.expand_path File.dirname(__FILE__) + "../../../../external/mongodb/bin/mongod --fork"
			dblogs = ENV['HOME'] + "/.esearchy/logs/mongodb.logs"
			dbpath = ENV['HOME'] + "/.esearchy/data/db"
			system( mongod + " --dbpath=" + dbpath + " --logpath=" + dblogs)
			sleep(1)
		rescue
			Display.error "Something went wrong starting db"
			exit(0)
		end
		def self.connect
			Display.msg "Connecting ESearchy to MongoDB"
			MongoMapper.connection = Mongo::Connection.new($globals[:dbhost] || "localhost", $globals[:dbport] || 27017)
			MongoMapper.database = $globals[:dbname] || "esearchy"
		rescue
			Display.error "There was an error connecing to the database." 
			Display.error "Make sure mongod is running and connections are correctly setup."
			exit(0)
		end

		def self.stop
			MongoMapper.connection['admin'].command(:shutdown => 1)
		rescue
			Display.error "Looks like there is nothing to shutdown"
		end
	end
end