guard :shell do
  watch(%r"src/.*") {
    system "make build"
  }
end

guard :shell do
  watch(%r"tutorials/([^/]+)/.*") { |m|
    name = m[1]
    puts "#{m[0]} changed"
    system "./build-tutorial #{name}"
  }
end

guard 'livereload' do
  watch(%r{^build/.*})
  watch(%r{^tutorials-build/.*html$})
  watch(%r{views/.*})
  watch(%r{server.coffee})
end
