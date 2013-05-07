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
	var mode = req.query.mode;
	var who = req.query.who;
	var how = req.query.how;
	var rating = req.query.rating;
	report(mode, who, how, rating, res);
});

app.get('/all', function(req, res){
	showAll(res);
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
	

function report(mode, who, how, rating, res) {
	console.log("report "+rating);
	// check if in db already
	common.mongo.collection('reports', function(e, c) {	
		c.insert({ mode: mode, who: who, how: how, rating: rating }, function(err, doc) {
  		var body = 'Hello World '+rating;
	    print({ success: body }, res);
		});
	});	
}

function showAll(res) {
	common.mongo.collection('reports', function(e, c) {	
		c.find().toArray(function(err, results) {
	    print({ success: results }, res);
		});
	});						
}


function print(data, res) {
  res.writeHead(200, { 'Content-Type': 'application/json' });   
  res.write(JSON.stringify(data));
  res.end();
}








