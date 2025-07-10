const express = require('express');

const app = express();

app.get('/', (req, res) => {
    res.status(200).send('hello world');
})

app.get('/healthz', (req, res) => {
    res.status(200).send('OK')
})

app.listen(3000, () => {
    console.log('App is listening on port 3000')
})