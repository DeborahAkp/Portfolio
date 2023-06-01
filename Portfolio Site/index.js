const express = require('express');
const path = require('path');
const app = express();
const port = 3000;

app.use(express.static('public/images'));
app.use(express.static('public/files'));

app.use(express.urlencoded({ extended: false }));


app.set('view engine', 'ejs')

app.get('/', (req, res) => {
    res.render('homePage')
})


app.get('/portfolio', (req, res) => {
    res.render('portfolio')
})

app.get('/portfolio/project-one', (req, res) => {
    res.render('projectOne')
})


app.get('/contact', (req, res) => {
    res.render('contactMe')
})

app.listen(port, () => {
    console.log(`Listening on port ${port}`)
})

app.use(express.static('public'));