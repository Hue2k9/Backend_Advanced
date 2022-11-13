const CatchAsync = require("../Middlewares/asyncHandle");
const multer = require("multer");
const sharp = require("sharp");

const multerStores = multer.memoryStorage();

const fileStorageEngine = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "../UPLOAD/public/uploads");
  },
  filename: (req, file, cb) => {
    // cb(null, Date.now() + "--" + file.originalname);
    cb(null, file.originalname);
  },
});

const upload = multer({ storage: fileStorageEngine });

module.exports = {
  upload,
};
