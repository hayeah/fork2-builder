guard :shell do
  watch(%r"src/.*") {
    system "make build"
  }
end

guard 'livereload' do
  watch(%r{build/.*})
  watch(%r{views/.*})
  watch(%r{server.coffee})
end
