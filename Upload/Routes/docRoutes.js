const express = require("express");
const router = express.Router();
const docController = require("../Controllers/docController");
const upload = require("../Middlewares/upload");
const docRouter = express.Router();

docRouter
  .route("/")
  //   .get(docController.uploadView)
  .post(upload.upload.single("file"), docController.splitPdf);

// docRouter.post(
//   "/multiple",
//   upload.upload.array("files", 3),
//   docController.multipleFile
// );

module.exports = docRouter;
