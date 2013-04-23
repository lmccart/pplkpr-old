/*
 * index.js
 *
 * godseyes
 *
 */

var http = require('http');
var common = require('./common.js');
var router = require('./router.js');

var express = require('express');
var app = express();


app.configure(function(){
  app.set('title', 'pplkpr');
})

/*
// development only
app.configure('development', function(){
  app.set('db uri', 'localhost/dev');
})

// production only
app.configure('production', function(){
  app.set('db uri', 'n.n.n.n/prod');
})
*/

app.get('/report', function(req, res){
	var rating = req.query.rating;

  var body = 'Hello World '+rating;
  res.setHeader('Content-Type', 'text/plain');
  res.setHeader('Content-Length', body.length);
  res.end(body);
});

app.listen(3000);
console.log('Listening on port 3000');

// open mongo connect
common.mongo.open(function(err, p_client) {
  if (err) { throw err; }
  console.log('mongo open');
  common.mongo.authenticate(common.config.mongo.user, common.config.mongo.pass, function (err, replies) {
    // You are now connected and authenticated.
    console.log('mongo authenticated');
    
  });
});
	

function report(req, res) {
	
	var p2pString = p2p ? 'enabled' : 'disabled';
	var tok = "";
	
	var versionExpired = (version < common.currVersion);
				
	// if force flag, reset session automatically
	// note: forcing streaming to false
	if (force) { // force create new session
		newSession(p2pString, function(sessionid) { 
			var tok = newToken(sessionid, false); 
			updateUser(deviceid, versionExpired, sessionid, tok, false, 0, false, res);
		});
	} else {

		// check if in db already
		common.mongo.collection('users', function(e, c) {	
			c.findOne({'deviceid':deviceid}, function(err, doc) {
				if (doc) { 
						var tok = newToken(doc.sessionid, false);
						var points = doc.points ? doc.points : 0;
						updateUser(deviceid, versionExpired, doc.sessionid, tok, false, points, doc.isGod, res);
				} else {  // create new id
					newSession(p2pString, function(sessionid) {
						var tok = newToken(sessionid, false);
						updateUser(deviceid, versionExpired, sessionid, tok, false, 0, false, res);
					});
				}
			});
		});
	}							
}
