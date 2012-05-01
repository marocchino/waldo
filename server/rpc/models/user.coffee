mongoose = require 'mongoose'

Schema = mongoose.Schema

Users = new Schema
  name: String,
  userId: String,
  email: String,
  picture: String,
  createdAt: {type: Date, default: Date.now}

mongoose.model 'User', Users
mongoose.connect "mongodb://#{ process.env.MONGODB_ID }:#{ process.env.MONGODB_PASSWORD }@localhost/waldo"

module.exports.User = mongoose.model 'User'
