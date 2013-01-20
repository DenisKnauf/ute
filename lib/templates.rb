module Templates
	class ImplementationExpected < Exception
	end

	@templates = Hash.new {|h,k| h[k] = [] }
	@preferred = {}
	class <<self
		def normalize ext
			ext.to_s.downcase.sub( /^\./, '').to_sym
		end

		def [] filename
			%r<\.([^./]+)$> =~ filename
			ext = normalize $1
			@preferred[ext] || @templates[ext][0]
		end

		def new filename, options = nil
			options[:filename] = filename
			engine = self[filename]
			engine && engine.new( options)
		end

		def register klass, *exts
			exts.each do |ext|
				@templates[normalize ext].unshift( klass).uniq!
			end
		end

		def prefer klass, *exts
			if exts.empty?
				@templates.each {|ext, klasses| @preferred[ext] = klass if klasses.include? klass }
			else
				register klass, *exts
				exts.each {|ext| @preferred[normalize ext] = klass }
			end
		end
	end
end
