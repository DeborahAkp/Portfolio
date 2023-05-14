const express = require('express')
const app = express()
const port = 3000


app.set('view engine', 'ejs')

app.get('/', (req, res) => {
    res.render('homePage')
})

app.get('/portfolio', (req, res) => {
    res.render('portfolio')
})

app.get('/contact', (req, res) => {
    res.render('contactMe')
})

app.listen(port, () => {
    console.log(`Listening on port ${port}`)
})
