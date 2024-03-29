var common = require('./common.js');

function route(url, res) {

  var pathname = common.url.parse(url).pathname;
  console.log("About to route a request for " + pathname);
  
  if (pathname === "/add_entry") {
  	var deviceid = common.qs.parse(url)["deviceid"];
  	var version = common.qs.parse(url)["version"];
  	var p2p = common.qs.parse(url)["p2p"];
  	var force = common.qs.parse(url)["force"];
  	
  	//console.log("deviceid:"+deviceid+" p2p:"+p2p+" force:"+force);	
  	authenticateUser(deviceid, version, p2p, force, res);
  	
  } 
  /*
  else if (pathname === "/remove_user") {
  	var deviceid = common.qs.parse(url)["deviceid"];
  	removeUser(deviceid, res);
  }
  else if (pathname === "/set_airship_token") {
  	var deviceid = common.qs.parse(url)["deviceid"];
  	var airshiptoken = common.qs.parse(url)["airshiptoken"];
  	setAirshipToken(deviceid, airshiptoken, res);
  }
  
  else if (pathname === "/user_session_started") {
  	var deviceid = common.qs.parse(url)["deviceid"];
  	var desc = common.qs.parse(url)["desc"];
  	var img = common.qs.parse(url)["img"];
	  setUserStreaming(deviceid, true, desc, img, res);
  } else if (pathname === "/user_session_ended") {
  	var deviceid = common.qs.parse(url)["deviceid"];
  	var points = common.qs.parse(url)["points"];
	  setUserStreaming(deviceid, false, "", "", res);
	  setUserPoints(deviceid, points, res);
  }
  
  else if (pathname === "/get_current_sessions") {
  	var streaming = common.qs.parse(url)["streaming"];
	  getCurrentSessions(streaming, res);
  }
  else if (pathname === "/enter_random_session") {
  	var streaming = common.qs.parse(url)["streaming"];
	  enterRandomSession(streaming, res);
  }
  else if (pathname === "/enter_session") {
	  var sessionid = common.qs.parse(url)["sessionid"];
	  enterSession(sessionid, res);
  }
  
  // DB management methods
  else if (pathname === "/god_ping") {
  	var deviceid = common.qs.parse(url)["deviceid"];
  	getCurrentSessions('true', res, godPing, deviceid);
  }
  else if (pathname === "/ping") {
  	var deviceid = common.qs.parse(url)["deviceid"];
  	var points = common.qs.parse(url)["points"];
	  setUserPoints(deviceid, points, res);
  }
  else if (pathname === "/clear_db") {
  	clearDB(res);
  }
  else if (pathname === "/refresh_db") {
  	refreshDB(res);
  }
  
  // god logics
  else if (pathname === "/set_god") {
  	var deviceid = common.qs.parse(url)["deviceid"];
  	setGod(deviceid, res);
  }
  else if (pathname === "/summon_eyes") {
	  common.broadcastPush("my eyes I summon you", [["type",1]], res);
  }
  else if (pathname === "/god_status") {
  	godStatus(res);
  }
  else if (pathname === "/message_god") {
  	var deviceid = common.qs.parse(url)["deviceid"];
  	var msg = common.qs.parse(url)["msg"];
	  messageGod(deviceid, msg, res);
  }
  
  // testing methods
  else if (pathname === "/test_send") {
  	var airshiptoken = common.qs.parse(url)["airshiptoken"];
	  common.sendPush(airshiptoken, "test send", [["type",4], ["additional","args"]], res);
  }*/
}


function authenticateUser(deviceid, version, p2p, force, res) {
	
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

function removeUser(deviceid, res) {
	common.mongo.collection('users', function(e, c) {	
		
		c.findAndModify({deviceid: deviceid}, {}, {}, {remove: true}, function(err, doc) {
			console.log("removed "+deviceid);
		});
		
    // return json with tok + sessionid
    res.writeHead(200, { 'Content-Type': 'application/json' });   
    res.write(JSON.stringify({ success:true, removed: deviceid}));
    res.end();
	});	
}

function newSession(p2p, cb) {
	console.log("opening new session");
	// create opentok session
	var location = common.config.ip; // use an IP or 'localhost'
	common.opentok.createSession(location, {'p2p.preference':p2p}, function(result){
		console.log("session opened "+result);
		cb(result);
	});
}


function newToken(sessionid, isGod) {
	var expire = isGod ? new Date().getTime() + (1000*60*60*24) : new Date().getTime() + (7*1000*60*60*24); // one day or one week

	var token = common.opentok.generateToken({session_id:sessionid, 
		role:common.OpenTok.RoleConstants.PUBLISHER, 
		expire_time: expire, 
		connection_data:"userId:42temp"}); //metadata to pass to other users connected to the session. (eg. names, user id, etc)
	return token;			
}


function updateUser(deviceid, expired, sessionid, tok, stream, points, isGod, res) {
	common.mongo.collection('users', function(e, c) {
		// upsert user with tok + id
		c.update({deviceid: deviceid},
			{$set: {sessionid: sessionid, token: tok, streaming: stream, points: points, isGod: isGod, updated: new Date().getTime(), expired:expired }}, 
			{upsert:true},
			function(err) {
        if (err) console.warn("MONGO ERROR "+err.message);
        else console.log('successfully updated');
        
        // return json with tok + sessionid
        res.writeHead(200, { 'Content-Type': 'application/json' });   
        res.write(JSON.stringify({ deviceid:deviceid, expired:expired, token:tok, sessionid:sessionid, streaming: stream, points: points, isGod: isGod, pointSpeeds: common.pointSpeeds}));
        res.end();
    });
	});
}

function setAirshipToken(deviceid, airshiptoken, res) {

	// register with ua
	common.ua.registerDevice(airshiptoken.toUpperCase(), function(error) {
		if (error) console.log("airship error! "+error);
		common.mongo.collection('users', function(e, c) {
			// upsert user with tok + id
			c.update({deviceid: deviceid},
				{$set: {airshiptoken: airshiptoken.toUpperCase()}}, 
				function(err) {
	        if (err) console.warn("MONGO ERROR "+err.message);
	        else console.log('successfully updated ua token '+airshiptoken.toUpperCase());
		        
	        // return json with tok + sessionid
	        res.writeHead(200, { 'Content-Type': 'application/json' });   
	        res.write(JSON.stringify({ deviceid:deviceid, airshiptoken:airshiptoken.toUpperCase()}));
	        res.end();
	    });
		});	
	});
}

function setUserStreaming(deviceid, streaming, desc, img, res) {
	common.mongo.collection('users', function(e, c) {
		// upsert user with tok + id
		c.update({deviceid: deviceid},
			{$set: {streaming: streaming, desc: desc, img: img, started: new Date().getTime() }}, 
			function(err) {
        if (err) console.warn("MONGO ERROR "+err.message);
        else console.log('successfully updated user streaming '+streaming);
        
        
        // return json with tok + sessionid
        res.writeHead(200, { 'Content-Type': 'application/json' });   
        res.write(JSON.stringify({ deviceid:deviceid, streaming: streaming, desc:desc, img:img}));
        res.end();
    });
	});	
}

// takes a callback, if none specified calls printResults
function getCurrentSessions(streaming, res, func, args) {
	var stream_args = {};
	if (streaming == 'true') stream_args = {streaming:true};
	else if (streaming == 'false') stream_args = {streaming:false};

	common.mongo.collection('users', function(e, c) {
		c.find(stream_args).toArray(function(err, results) {
			console.log(results+" "+err);
			if (func) func(results, res, args);
			else printResults(results, res);
		});
  });
}

function printResults(results, response) {
    response.writeHead(200, { 'Content-Type': 'application/json' });   
    response.write(JSON.stringify(results));
    response.end();
}

function enterRandomSession(streaming, res) {
	var args = {};
	if (streaming == 'true') args = {streaming:true};
	else if (streaming == 'false') args = {streaming:false};

	common.mongo.collection('users', function(e, c) {
	
		c.find(args).count(function(err, num) {
			if (num > 0) {
				var n = Math.floor(Math.random()*num);
				c.find(args).limit(-1).skip(n).toArray(function(err, results) {
					console.log(results[0].sessionid);
		      enterSession(results[0].sessionid, res);
				});
			} else {
		    res.header('Access-Control-Allow-Origin', '*' );
		    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
		    res.header('Access-Control-Allow-Headers', 'Content-Type');
        res.writeHead(200, { 'Content-Type': 'application/json' });   
        res.write(JSON.stringify({status:"no sessions available"}));
        res.end();
			}
		});
		
  });
}


function enterSession(sessionid, res) {
	var tok = newToken(sessionid, true);

  // return json with tok + sessionid
  res.writeHead(200, { 'Content-Type': 'application/json' });   
  res.write(JSON.stringify({ token:tok, sessionid:sessionid }));
  res.end();

}


function setUserPoints(deviceid, points, res) {
	common.mongo.collection('users', function(e, c) {
		c.update({deviceid: deviceid},
			{$set: {points: parseInt(points, 10), streaming: true, updated: new Date().getTime() }}, 
			function(err) {
        if (err) console.warn("MONGO ERROR "+err.message);
        else console.log('successfully updated user points '+points);

        godStatus(res);
    });
	});	
}

function setGod(deviceid, res) {

	common.mongo.collection('users', function(e, c) {
		c.findAndModify({isGod: true}, {}, {$set: {isGod: false}}, {upsert: false},
			function(err, object) {
        if (err) console.warn("MONGO ERROR "+err.message);
        if (object) {	
        	console.log('removed god '+object.deviceid);
        	common.sendPush(object.airshiptoken, 'You are no longer god', [["type", 0]]);
        } else console.log('no current god');
        
        var godExpire = new Date(new Date().getTime() + 5*60*1000);
        c.update({deviceid: deviceid},
					{$set: {isGod: true, godExpire: godExpire, points: 0 }}, // 5 min expire for now
					function(err) {
		        if (err) console.warn("MONGO ERROR "+err.message);
		        console.log('god is now '+deviceid);
		        
		        // return json with tok + sessionid
		        res.writeHead(200, { 'Content-Type': 'application/json' });   
		        res.write(JSON.stringify({ success:true, god:deviceid, godExpire: godExpire}));
		        res.end();
		    });		        
		  });
	});	


}

function godPing(sessions, res, deviceid) {
	console.log("deviceid ="+deviceid);
	common.mongo.collection('users', function(e, c) {	
		c.findOne({deviceid:deviceid}, function(err, doc) {
			var isGod = false;
			if (doc) { 
				isGod = doc.isGod;
				console.log("doc = "+doc);
			} else console.log('no doc found');
					
	    // return json with tok + sessionid
	    res.writeHead(200, { 'Content-Type': 'application/json' });   
	    res.write(JSON.stringify({ isGod:isGod, sessions:sessions}));
	    res.end();
		});
	});
}

function godStatus(res) {
		// check if in db already
	common.mongo.collection('users', function(e, c) {	
		c.findOne({isGod:true}, function(err, doc) {
			var timeGodhoodAvailable = new Date().toISOString();
			var godhoodAvailable = true;
			if (doc) { 
				godhoodAvailable = new Date() > doc.godExpire;
				timeGodhoodAvailable = doc.godExpire.toISOString();
			} else {  
				console.log("no god found");
			}
		
      res.writeHead(200, { 'Content-Type': 'application/json' });   
      res.write(JSON.stringify({ godhoodAvailable: godhoodAvailable, timeGodhoodAvailable: timeGodhoodAvailable, godSummonable: false, pointSpeeds: common.pointSpeeds }));
      res.end();
		});
	});
}

function messageGod(deviceid, msg, res) {
	common.mongo.collection('users', function(e, c) {	
		c.findOne({isGod:true}, function(err, doc) {
			if (doc) { 
			 
  			c.findOne({deviceid:deviceid}, function(err, ddoc) {
    			var sessionid = "";
    			var desc = "";
    			if (ddoc) {
      			sessionid = ddoc.sessionid;
      			desc = ddoc.desc.substring(0, Math.min(ddoc.desc.length,75));
    			}
  				common.sendPush(doc.airshiptoken, msg, [["type",3], ["sessionid",sessionid], ["desc", desc]], res);
          res.writeHead(200, { 'Content-Type': 'application/json' });   
          res.write(JSON.stringify({ status: "message sent" }));
          res.end();
        });
			} else {  
				console.log("no god found");
        // no god, time=0
        res.writeHead(200, { 'Content-Type': 'application/json' });   
        res.write(JSON.stringify({ status: "no god found."}));
        res.end();
			}
		});
	});
}

function clearDB(res) {
	
	common.mongo.collection('users', function(e, c) {
    c.drop(function(err, reply) {
	    getCurrentSessions('', res);
    });
  });
}

function refreshDB() {
	common.mongo.collection('users', function(e, c) {	
		var t = new Date().getTime() - (15*1000);
		
		c.findAndModify({updated: { $lt: t}, streaming: true}, {}, {$set: {streaming: false}}, {upsert: false}, function(err, doc) {
			if (doc) console.log("removed "+doc.deviceid);
		});
	});
}

exports.route = route;
exports.refreshDB = refreshDB;



