const asyncHandle = require("../Middlewares/asyncHandle");
const Document = require("../Models/document.model");
const Segment = require("../Models/segment.model");
const unzipper = require("unzipper");
const path = require("path");
const xml2js = require("xml2js");
const docxConverter = require("docx-pdf");
const fs = require("fs");

const upload = asyncHandle(async (req, res) => {
  await fs
    .createReadStream(req.file.path)
    .pipe(unzipper.Extract({ path: path.join(__dirname, "../public/uploads") }))
    .promise();

  let file = req.file.path;
  //convert docx to pdf
  docxConverter(file, `${file}.pdf`, function (err, result) {
    if (err) {
      console.log(err);
    }
    console.log("result" + result);
  });

  let document;

  //Document
  fs.readFile(
    path.join(__dirname, "../public/uploads/docProps/app.xml"),
    "utf8",
    async function (err, data) {
      let pages = data.split("<Pages>")[1].split("</Pages>")[0];
      let name = req.file.originalname;
      let path = req.file.path;
      let ext = req.file.originalname.split(".");
      document = new Document({
        fileName: name,
        path: path,
        ext: ext[req.file.originalname.split(".").length - 1],
        pages: pages,
      });
      await document.save();
      console.log(document);
    }
  );

  //Segment
  fs.readFile(
    path.join(__dirname, "../public/uploads/word/document.xml"),
    "utf-8",
    async function (err, data) {
      const parser = new xml2js.Parser({ explicitArray: false });
      parser.parseString(data, (error, result) => {
        res.send(result);
        result["w:document"]["w:body"]["w:p"].forEach((element) => {
          if (element["w:r"]) {
            if (element["w:r"]["w:t"]) {
              const sentences = element["w:r"]["w:t"]
                .replace(/([.?!])\s*(?=[A-Z])/g, "$1|")
                .split("|");
              sentences.forEach(async (sentence) => {
                // console.log(sentence);
                const segment = new Segment({
                  document: document._id,
                  text: sentence,
                });
                if (element["w:r"]["w:rPr"]) {
                  segment.bold =
                    element["w:r"]["w:rPr"]["w:b"]?.length == 0 ? true : false;
                  segment.italic =
                    element["w:r"]["w:rPr"]["w:i"]?.length == 0 ? true : false;
                  segment.underline =
                    element["w:r"]["w:rPr"]["w:u"]?.length == 0 ? true : false;
                  segment.strike =
                    element["w:r"]["w:rPr"]["w:strike"]?.length == 0
                      ? true
                      : false;
                }

                await segment.save();
                console.log(segment);
              });
            }
          }
        });
      });
    }
  );
});

// const uploadView = asyncHandle(async (req, res) => {
//   res.render("upfile.ejs");
// });

const multipleFile = asyncHandle(async (req, res) => {
  console.log(req.files);
  res.send("Multiple files upload sucess!");
});

module.exports = {
  upload,
  multipleFile,
  // uploadView,
};
