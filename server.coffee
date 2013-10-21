express = require('express')
ehbs = require("express3-handlebars")

app = express()

app.engine('.hbs', ehbs({defaultLayout: 'main',extname: '.hbs'}))
app.set('view engine', '.hbs')

app.get '/', (req,res) ->
  res.render('home')

app.use(express.static(__dirname))

app.listen(3000)
