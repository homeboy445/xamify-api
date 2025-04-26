require("dotenv").config();

// express
const express = require("express");
const app = express();
const cors = require("cors");
app.use(express.json());
app.use(cors());

// routes
app.use("/api", require("./routes"));

app.get("/", (req, res) => {
    res.json("Server's live!");
});

// error handler
app.use(async(err, req, res, next) => {
    if (res.headersSent) {
        return next(err);
    }
    res
        .status(err.status || 500)
        .send({ error: err.message || "Some error occured" });
});

module.exports = app.listen(process.env.PORT || 8000, () => {
    console.log(`Server running at ${PORT}`);
});