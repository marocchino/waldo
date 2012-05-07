mongoose = require 'mongoose'

Schema = mongoose.Schema

Comments = new Schema
  userId: String
  text:   String
  createdAt: {type: Date,   default: Date.now}

Translations = new Schema
  userId: String
  text:   String
  local:     {type: String, default: "ko_KR"}
  createdAt: {type: Date,   default: Date.now}

Lines  = new Schema
  original:      String
  comments:     [Comments]
  translations: [Translations]

Posts  = new Schema
  url:       {type: String, index: true, unique: true}
  userId:    {type: String, index: true}
  lines:     [Lines]
  local:     {type: String, default: "en_US"}
  createdAt: {type: Date,   default: Date.now}
  title:     {type: String}

mongoose.model 'Post', Posts
mongoose.connect "mongodb://#{ process.env.MONGODB_ID }:#{ process.env.MONGODB_PASSWORD }@localhost/waldo"

module.exports.Post = mongoose.model 'Post'
