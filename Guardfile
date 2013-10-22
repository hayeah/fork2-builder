guard :shell do
  watch(%r"src/.*") {
    system "make build"
  }
end

guard :shell do
  watch(%r"tutorials/([^/]+)/.*") { |m|
    name = m[1]
    system "./build-slidecast.coffee -i tutorials/#{name} -o tutorials-build/#{name}"
  }
end

guard 'livereload' do
  watch(%r{^build/.*})
  watch(%r{^tutorials-build/.*})
  watch(%r{views/.*})
  watch(%r{server.coffee})
end
