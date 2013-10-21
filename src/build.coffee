{
  appDir: "."
  baseUrl: "."
  mainConfigFile: "main.js"
  optimize: "uglify2"
  skipDirOptimize: true
  modules: [
    {
      name: "vendor"
    }
    {
      name: "main"
      exclude: ["vendor"]
    }
  ]
}