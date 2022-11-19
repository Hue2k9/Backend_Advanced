const asyncHandle = require("../Middlewares/asyncHandle");
const Document = require("../Models/document.model");
const Segment = require("../Models/segment.model");
const unzipper = require("unzipper");
const path = require("path");
const xml2js = require("xml2js");
const docxConverter = require("docx-pdf");
const {
  WordsApi,
  SplitDocumentRequest,
  CommentsCollection,
} = require("asposewordscloud");
const fs = require("fs");
const PDFExtract = require("pdf.js-extract").PDFExtract;
const pdfExtract = new PDFExtract();
const pdf = require("pdf-parse");
const PDFDocument = require("pdf-lib").PDFDocument;
const libre = require("libreoffice-convert");
libre.convertAsync = require("util").promisify(libre.convert);
var toPdf = require("custom-soffice-to-pdf");
const doc = require("file-convert");

const splitPdf = asyncHandle(async (req, res) => {
  let name = req.file.originalname;
  const options = {
    libreofficeBin: "D:\\program\\soffice.exe",
    sourceFile: req.file.path, // .ppt, .pptx, .odp, .key and .pdf
    outputDir: "D:\\nodejs\\Backend_nangcao\\Upload\\public\\uploads",
    img: false,
    imgExt: "jpg", // Optional and default value png
    reSize: 800, //  Optional and default Resize is 1200
    density: 120, //  Optional and default density value is 120
    disableExtensionCheck: true, // convert any files to pdf or/and image
  };

  // Convert document to pdf and/or image
  await doc
    .convert(options)
    .then((res) => {
      console.log("Convert pdf successfully!\n", res); // Success or Error
    })
    .catch((e) => {
      console.log("e", e);
    });

  let newName = name.split(".");
  const docmentAsBytes = await fs.promises.readFile(
    `./public/uploads/${newName[0]}.pdf`
  );

  // Load your PDFDocument
  const pdfDoc = await PDFDocument.load(docmentAsBytes);
  const numberOfPages = pdfDoc.getPages().length;
  let numberReview = numberOfPages / 3 + 1;
  console.log("Tổng số trang: " + numberOfPages);
  console.log("Số trang review: " + numberReview);

  // Create a new "sub" document
  const subDocument = await PDFDocument.create();

  for (let i = 0; i < numberReview; i++) {
    // copy the page at current index
    const [copiedPage] = await subDocument.copyPages(pdfDoc, [i]);
    // add page
    subDocument.addPage(copiedPage);
  }

  const pdfBytes = await subDocument.save();

  await writePdfBytesToFile(`./public/uploads/review-${name}.pdf`, pdfBytes);

  fs.unlinkSync(`./public/uploads/${newName[0]}.pdf`);

  res.status(201).send("success");

  //========================= Read file XML=======================================
  /*
   // await fs
  //   .createReadStream(req.file.path)
  //   .pipe(unzipper.Extract({ path: path.join(__dirname, "../public/uploads") }))
  //   .promise();
  let document;
  res.send("sucess!");
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

  // //Segment
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
  */
});

function writePdfBytesToFile(fileName, pdfBytes) {
  return fs.promises.writeFile(fileName, pdfBytes);
}

const uploadView = asyncHandle(async (req, res) => {
  res.render("upfile.ejs");
});

const multipleFile = asyncHandle(async (req, res) => {
  console.log(req.files);
  res.send("Multiple files upload sucess!");
});

module.exports = {
  splitPdf,
  multipleFile,
  uploadView,
};
