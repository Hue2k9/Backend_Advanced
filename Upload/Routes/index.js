const docRouter = require("./docRoutes");

module.exports = (app) => {
  app.use("/api/upload", docRouter);
};
