var express = require('express');
var app = express();
var logger = require("morgan");

var movies = {movies: [
  {id: 1, title: "The Shining"},
  {id: 2, title: "2001: A Space Odyssey"},
  {id: 3, title: "Barry Lydon"}
]};

app.use(logger("combined"));

app.get('/movies', function (req, res) {
  res.send(movies);
});

app.listen(8080, function () {
    console.log('Example app listening on port 8080!');
});

