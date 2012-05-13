// My SocketStream app

var http = require('http')
  , ss = require('socketstream')
  , everyauth = require('everyauth');

// Define a single-page client
ss.client.define('main', {
  view: 'app.jade',
  css:  ['libs', 'app.less'],
  code: ['libs', 'app'],
  tmpl: '*'
});

// Serve this client on the root URL
ss.http.route('/', function(req, res){
  res.serveClient('main');
})

// Code Formatters
ss.client.formatters.add(require('ss-coffee'));
ss.client.formatters.add(require('ss-jade'));
ss.client.formatters.add(require('ss-less'));

// Use server-side compiled Hogan (Mustache) templates. Others engines available
ss.client.templateEngine.use(require('ss-hogan'));

// Minimize and pack assets if you type: SS_ENV=production node app.js
if (ss.env == 'production') ss.client.packAssets();

ss.session.store.use("redis");
ss.publish.transport.use('redis');

everyauth.facebook
  .appId(process.env.FACEBOOK_APP_ID)
  .appSecret(process.env.FACEBOOK_APP_SECRET)
  .scope('email')
  .findOrCreateUser(function(session, accessToken, accessTokExtra, fbUserMetadata){
    session.userId  = fbUserMetadata.id;
    session.name    = fbUserMetadata.name;
    session.email   = fbUserMetadata.email;
    session.picture = fbUserMetadata.picture;
    session.save();
    return true;
  }).redirectPath('/');
everyauth.everymodule.moduleErrback( function (err) {  // Time Out etc...
  console.log(err);
});
everyauth.everymodule.handleLogout( function (req, res) { // Logout
  req.logout();
  delete req.session.userId;
  delete req.session.email;
  delete req.session.name;
  delete req.session.picture;
  this.redirect(res,'/');
});
ss.http.middleware.append(everyauth.middleware());

// Start web server
var server = http.Server(ss.http.middleware);
server.listen(3000);

// Start Console Server (REPL)
// To install client: sudo npm install -g ss-console
// To connect: ss-console <optional_host_or_port>
//var consoleServer = require('ss-console')(ss);
//consoleServer.listen(5000);

// Start SocketStream
ss.start(server);
