mongoose = require 'mongoose'

Schema = mongoose.Schema
Comments = new Schema
  userId: String
  createdAt: {type: Date, default: Date.now}
Translations = new Schema
  local:  String
  userId: String
  createdAt: {type: Date, default: Date.now}
Lines  = new Schema
  orignal:      String
  comments:     [Comments]
  translations: [Translations]

Posts  = new Schema
  url:    String
  userId: String
  text:   String
  locals: String
  lines:  [Lines]
  createdAt: {type: Date, default: Date.now}

mongoose.model 'Post', Posts
mongoose.connect "mongodb://#{ process.env.MONGODB_ID }:#{ process.env.MONGODB_PASSWORD }@localhost/waldo"

module.exports.Post = mongoose.model 'Post'
