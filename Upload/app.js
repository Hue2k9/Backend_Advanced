const express = require("express");
const path = require("path");
const dotenv = require("dotenv");
const methodOverride = require("method-override");
const cookies = require("cookie-parser");
const app = express();
const port = 3000;

const router = require("./Routes/index");
const ErrorResponse = require("./common/ErrorResponse");
const db = require("./config/db");
const multer = require("multer");

dotenv.config();
app.use(express.json());
app.use(methodOverride("_method"));
app.use("/static", express.static("public"));
app.use(cookies());
// app.use(ErrorResponse);

app.use(express.static(path.join(__dirname, "public")));
app.use(express.urlencoded({ extended: true }));

app.set("view engine", "ejs");
app.set("views", "./resources/views");

router(app);
app.listen(port, () => {
  console.log(`App listening on port http://localhost:3000/api/upload`);
});
