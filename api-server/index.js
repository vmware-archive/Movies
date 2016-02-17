"use strict";

let express = require("express");
let app = express();
let logger = require("morgan");

let apiResponse = {
  movies: [
    {id: 1, title: "The Shining"},
    {id: 2, title: "2001: A Space Odyssey"},
    {id: 3, title: "Barry Lydon"}
  ]
};

app.use(logger("combined"));

app.get("/movies", (req, res) => {
  res.send(apiResponse);
});

app.listen(8080, () => {
    console.log("Example app listening on port 8080!");
});

