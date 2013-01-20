class Templates::Engine
	class <<self
		# don't forget to implement initialize for your engine.
		# @initialized must be set to true or false like return:
		# return: true:  engine can be provieded
		#         false: engine can not be provieded (lib not found for example)
		def initialize
			raise ImplementationExpected, "Implementation for #{name}.initialize needed"
		end

		def require_template_library *libs
			libs.each {|lib| require lib }
			true
		rescue LoadError
			return false
		end

		def initialized?() @initialized end

		def register *exts
			@extentions = exts
			Templates.register self, *exts
		end
	end

	attr_reader :options, :filename, :line, :data

	def initialize options = nil
		@options = options.nil? ? {} : options.dup
		@options[:filename] ||= @options[:file].nil? ? '`(_}-{_)`' : @options[:file].path
		@filename = @options[:filename]
		@line = @options[:line] || 1
		@data = if @options[:content]
				@options[:content]
			elsif @options[:file]
				@options[:file].read
			elsif @options[:filename]
				File.read @options[:filename]
			end
	end

	def evaluate
		raise ImplementationExpected, "Implementation for #{name}#evaluate needed"
	end

	def prepare
		raise ImplementationExpected, "Implementation for #{name}#prepare needed"
	end

	def output
		@output ||= evaluate
	end

	def render
		prepare
		output
	end
end
