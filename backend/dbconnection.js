const mongoose = require("mongoose");
const db = mongoose.connect(process.env.DB, {
}).then(() => {
        console.log("Connected to MongoDB Atlas!");
    })
    .catch((error) => {
        console.log("Error connecting to MongoDB: ", error);
    });

module.exports = db;