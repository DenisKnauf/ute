class Templates::Engines::Kramdown < Templates::Engine
	DUMB_QUOTES = [39, 39, 34, 34]

	class <<self
		def initialized?
			defined? ::Kramdown
		end

		def initialize
			require_template_library 'kramdown'
		end
	end

	def prepare
		options = @options[:options]
		options = options.nil? ? {} : options.dup
		options[:smart_quotes] = DUMB_QUOTES unless options[:smartypants]
		@engine = ::Kramdown::Document.new @data, options
		@output = nil
	end

	def evaluate
		@engine.to_html
	end

	register :markdown, :mkd, :md
end
