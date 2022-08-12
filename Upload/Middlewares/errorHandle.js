const ErrorResponse = require("../common/ErrorResponse");
const errorHandle = (err, req, res, next) => {
  let error = { ...err };
  error.message = err.message;

  console.log(err.stack);

  if (err.code === 11000) {
    error = new ErrorResponse("Dữ liệu trùng", 400);
  }
  if (err.name === "ValidationError") {
    const message = Object.values(err.errors).map((value) => value.message);
    error = new ErrorResponse(message, 400);
  }
  res.status(error.statusCode || 500).json({
    msg: error.message || "Lỗi máy chủ",
  });
};
module.exports = errorHandle;
