const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const segmentSchema = new Schema(
  {
    document: {
      type: Schema.Types.ObjectId,
      ref: "Document",
    },
    text: {
      type: String,
    },
    bold: {
      type: Boolean,
      default: false,
    },
    underline: {
      type: String,
      default: false,
    },
    strike: {
      type: Boolean,
      default: false,
    },
    italic: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamp: true,
  }
);

module.exports = mongoose.model("Segment", segmentSchema);
