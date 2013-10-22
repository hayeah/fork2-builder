express = require('express')
ehbs = require("express3-handlebars")

app = express()

app.engine('.hbs.html', ehbs({defaultLayout: 'main',extname: '.hbs.html'}))
app.set('view engine', '.hbs.html')

app.get '/', (req,res) ->
  res.render('home')

app.use(express.static(__dirname))

app.listen(3000)
