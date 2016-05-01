"use strict";

let express = require("express");
let app = express();
let logger = require("morgan");

let apiResponse = {
  movies: [
    {id: 1, title: "The Shining", director: "Stanley Kubrick"},
    {id: 2, title: "2001: A Space Odyssey", director: "Stanley Kubrick"},
    {id: 3, title: "Barry Lydon", director: "Stanley Kubrick"}
  ]
};

app.use(logger("combined"));

app.get("/movies", (req, res) => {
  res.send(apiResponse);
});

app.listen(8080, () => {
    console.log("Example app listening on port 8080!");
});

