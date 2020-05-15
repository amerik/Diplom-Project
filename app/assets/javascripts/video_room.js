var RECPLAY_STATE_NONE = 0;
var PLUBLISHING_OWN_FEED = 1;
var USER_MEADIA = 2;
var USER_MEADIA_CAPTURE_SCREEN = 3;
var ATTACH_FEED = 3;

class JanusVideoRoom {
  constructor(opt) {
    this.opt = opt;
    this.ctx = null;
    this.handle = null;
    this.state = RECPLAY_STATE_NONE;
    this.stream = null;
    this.offer = null;
    this.room = opt.room;
    this.medias = null;
    this.capture = "screen";
    this.record = opt.record;
    this.stream = null;
  }

  async init(janusContext) {

    this.ctx = janusContext;
    if (!this.ctx) {
      throw new Error("Given JanusContext is invalid.");
    }

    this.ctx.janus.attach({
      plugin: "janus.plugin.videoroom",
      success: (pluginHandle) => { this.onSuccess(pluginHandle); },
      error: (err) => { this.onError(err); },
      consentDialog: (on) => { this.onConsentDialog(on); },
      webrtcState: (isOk, msg) => { this.onWebRtcState(isOk, msg); },
      iceState: (state) => { this.onIceState(state); },
      mediaState: () => { this.onMediaState(); },
      slowLink: () => { this.onSlowLink(); },
      onmessage: (msg, jsep) => { this.onMessage(msg, jsep); },
      onlocalstream: (stream) => { this.onLocalStream(stream); }, 
      ondataopen: () => { this.onDataOpen(); },
      ondata: () => { this.onData(); },
      oncleanup: () => { this.onCleanUp(); },
      detached: () => { this.onDetached(); },
    });

    return true;
  }

  /* ---------------------------------------------------------------------- */


  async createRoomAndjoin(){
    var register = { "request" : "create", "room" : this.room, "permanent" : false, "description" : "Call Room", "is_private" : true, "publishers": 2,  "rec_dir": "/home/panchuk/records" }; 
    this.handle.send({"message": register});  
    var join = { "request": "join", "room": this.room, "ptype": "publisher", "display": 'room'  };
    this.handle.send({"message": join});      
  }

  async CancelCall(room){
    // this.handle.send({
    //   message: {
    //     request: "leave"
    //   }
    // }); 
    //this.ctx.destroy();      
   // var destroy = { "request" : "destroy", "room" : this.room, "permanent" : true}; 
    //this.handle.send({"message": destroy});      
    //return Promise.resolve();
    this.room = room;
    return new Promise((resolve, reject) => {
      this.handle.send({
        message: { "request" : "destroy", "room" : this.room, "permanent" : true},  
        success: (jsep) => {
          Janus.debug("Got publisher SDP!");
          resolve(jsep);
        },
        error: (err) => {
          reject(err);
        }
      });
    });

  }
  /* ---------------------------------------------------------------------- */
  
  async createOffer() {
    return new Promise((resolve, reject) => {
      this.handle.createOffer({
        media: this.medias,  
        success: (jsep) => {
          Janus.debug("Got publisher SDP!");
          resolve(jsep);
        },
        error: (err) => {
          reject(err);
        }
      });
    });
  }

  async publishOwnFeed(useAudio) {
    // Publish our stream 
    this.medias = {audioRecv: false, videoRecv: false, audioSend: useAudio, videoSend: true };
    this.offer = await this.createOffer();
    this.state = PLUBLISHING_OWN_FEED;

    // this.handle.send({
    //   "message": {
    //     "request": "configure",
    //     "audio": useAudio, 
    //     "video": true,
    //     "video-bitrate-max": 320 * 240,
    //     "video-keyframe-interval": 10000,
    //   }
    // });
    var record = false;
    if(this.record == 'true'){ record = true; }
    var filename = $('#call_config').val();
    this.handle.send({
      "message": {
        "request": "publish",
        "record": record,
        "video": true,
        "audio": useAudio,
        "filename": filename
      },
      "jsep": this.offer
    });
  }


  async startScreenCapture(){
    var handle = this.handle;
    this.handle.createOffer({
      media: {
        video: "screen",
        replaceVideo: true
      },
      success: function(jsep) {
        Janus.debug(jsep);
        handle.send({message: {audio: true, video: true}, "jsep": jsep});
      },
      error: function(error) {
        // alert("WebRTC error... " + JSON.stringify(error));
      }
    });
  }

  async VideoShare(){
    var handle = this.handle;
    this.handle.createOffer({
      media: {
        video: true,
        replaceVideo: true
      },
      success: function(jsep) {
        Janus.debug(jsep);
        handle.send({message: {audio: true, video: true}, "jsep": jsep});
      },
      error: function(error) {
        // alert("WebRTC error... " + JSON.stringify(error));
      }
    });
  }

  async Mute(){
    this.handle.send({
      message: { "request" : "configure", "audio" : false},  
      success: (jsep) => {
        Janus.debug("Got publisher SDP!");
      },
      error: (err) => {
        // alert(err);
      }
    });   
  }

  async UnMute(){
    this.handle.send({
      message: { "request" : "configure", "audio" : true},  
      success: (jsep) => {
        Janus.debug("Got publisher SDP!");
      },
      error: (err) => {
        alert(err);
      }
    });
  }

  async newRemoteFeed(id, display, audio, video){
    await AttachJanus_remote(id, display, audio, video, this.room); 
  }
  /* ---------------------------------------------------------------------- */
  
  onSuccess(pluginHandle) {
    this.handle = pluginHandle;
    this.room = this.opt.room;
    this.opt.on_success();     
  }
  
  onMessage(msg, jsep) {
    Janus.debug(" ::: Got a message (subscriber) :::");
    Janus.debug(msg);
    var event = msg["videoroom"];
    Janus.debug("Event: " + event);  
    //alert(event);
    if(event != undefined && event != null) {
      if(event === "joined") {
        // Publisher/manager created, negotiate WebRTC and attach to existing feeds, if any
        var myid = msg["id"];
        var mypvtid = msg["private_id"];
        Janus.log("Successfully joined room " + msg["room"] + " with ID " + myid);
        this.publishOwnFeed(true);
        // Any new feed to attach to?
        if(msg["publishers"] !== undefined && msg["publishers"] !== null) {
          var list = msg["publishers"];
          Janus.debug("Got a list of available publishers/feeds:");
          Janus.debug(list);
          for(var f in list) {
            var id = list[f]["id"];
            var display = list[f]["display"];
            var audio = list[f]["audio_codec"];
            var video = list[f]["video_codec"];
            Janus.debug("  >> [" + id + "] " + display + " (audio: " + audio + ", video: " + video + ")");
            this.newRemoteFeed(id, display, audio, video);
          }
        }
      }
      else if(event === "destroyed") {
        // The room has been destroyed
        // alert('destroyed');
        Janus.warn("The room has been destroyed!");
        // location.reload();
        video_call_block()
      } 
      else if(event === "event") {
        // Any new feed to attach to?
        if(msg["publishers"] !== undefined && msg["publishers"] !== null) {
          var list = msg["publishers"];
          Janus.debug("Got a list of available publishers/feeds:");
          //alert(list);
          Janus.debug(list);
          for(var f in list) {
            var id = list[f]["id"];
            var display = list[f]["display"];
            var audio = list[f]["audio_codec"];
            var video = list[f]["video_codec"];
            Janus.debug("  >> [" + id + "] " + display + " (audio: " + audio + ", video: " + video + ")");
            this.newRemoteFeed(id, display, audio, video);
          }
        }

        else if(msg["leaving"] !== undefined && msg["leaving"] !== null) {
          reset_call()
          var leaving = msg["leaving"];
          Janus.log("Publisher left: " + leaving);    
          var remoteFeed = null;
          for(var i=1; i<2; i++) {
            if(feeds[i] != null && feeds[i] != undefined && feeds[i].rfid == leaving) {
              remoteFeed = feeds[i];
              break;
            }
          }
          if(remoteFeed != null) {
            Janus.debug("Feed " + remoteFeed.rfid + " (" + remoteFeed.rfdisplay + ") has left the room, detaching");
            $('#remote'+remoteFeed.rfindex).empty().hide();
            $('#videoremote'+remoteFeed.rfindex).empty();
            feeds[remoteFeed.rfindex] = null;
            remoteFeed.detach();
          }              
        }         
      }


      else if(msg["unpublished"] !== undefined && msg["unpublished"] !== null) {
        var unpublished = msg["unpublished"];
        if(unpublished === 'ok') {
          // That's us
          //this.handle.hangup();
          //alert('unpublished one');
          return;
        }        
      }    
    }  
    if(jsep !== undefined && jsep !== null) {
      Janus.debug("Handling SDP as well...");
      Janus.debug(jsep);
      this.handle.handleRemoteJsep({jsep: jsep});
      // Check if any of the media we wanted to publish has
      // been rejected (e.g., wrong or unsupported codec)
      var audio = msg["audio_codec"];
      var video = msg["video_codec"];
      if(this.stream && this.stream.getAudioTracks() && this.stream.getAudioTracks().length > 0 && !audio) {
        // Audio has been rejected
        alert("Our audio stream has been rejected, viewers won't hear us");
      }
      
      if(this.stream && this.stream.getVideoTracks() && this.stream.getVideoTracks().length > 0 && !video) {
        // Video has been rejected
        alert("Our video stream has been rejected, viewers won't see us");
        // Hide the webcam video
      }
    }

  }

  onError(err) {
    console.error(err);
  }

  /* Might add some more feature later. */
  onConsentDialog(on) {}
  onWebRtcState(isOk, msg) {}
  onIceState(state) { }
  onMediaState() { }
  onSlowLink() {  }
  onLocalStream(stream) { 
    Janus.attachMediaStream($('#local-stream').get(0), stream);
    this.stream = stream;
    $("#local-stream").get(0).muted = "muted";
    var videoTracks = stream.getVideoTracks();
    if(videoTracks === null || videoTracks === undefined || videoTracks.length === 0) {
      // No webcam
      $('.local').html('No Local webcam');
    }
  }
  onDataOpen() { }
  onData() { }
  onCleanUp() { }
  onDetached() { 
    // var destroy = { "request" : "destroy", "room" : this.room, "permanent" : true}; 
    // this.handle.send({"message": destroy});
  }
};

/* ---------------------------------------------------------------------- */

class JanusContext {

  constructor() {
    this.is_initialized = false
  }

  async init() {
    await this.initJanus();
    await this.initSession();
  }

  async initJanus() {
    return new Promise((resolve, reject) => {
      if (true == this.is_initialized) {
        throw new Error("Already initialized.");
      }
      Janus.init({
        debug: 'all',
        dependencies: Janus.useDefaultDependencies(),
        callback: () => {
          this.is_initialized = true;
          resolve();
        }
      });
    });
  }
  
  async initSession() {
    return new Promise((resolve, reject) => {
      this.janus = new Janus({
        server: "https://" +document.location.hostname +":8089/janus",
        success: resolve,
        error: reject,
        destroyed: function() {
          window.location.reload();
          console.log("Janus session destroyed. @todo cleanup.");
        }
      });
    });
  }

  async attachPlugin(plugin) {
    if (!plugin) {
      throw new Error("Plugin is invalid.");
    }
    return plugin.init(this);
  }
};

/* ---------------------------------------------------------------------- */

jr = new JanusContext();
jr.init();

var AttachJanus = async function() {
  video_room = new JanusVideoRoom({
    el_video: document.querySelector("#local-stream"),
    room: parseInt($('#room').val()),
    record: $('#is_mentor').val(),
    on_success: async () => {
      Janus.log("Plugin attached! (" + video_room.handle.getPlugin() + ", id=" + video_room.handle.getId() + ")");    
      video_room.createRoomAndjoin();
    },
    on_recording_started: () => {
      alert("start");
    },
    on_recording_stopped: () => {
      alert('stoped');
    },
  });


  try {
    try {
      await jr.attachPlugin(video_room);
      //await video_room.startVideoInput(false, true);
    }
    catch (e) {
      console.error(e);
    }
  }
  catch (e) {
    console.error(e);
  }
}



// $(document).on("click", "#start_call", function() { 
//   video_room.createRoomAndjoin();
// })

// $(document).on("click", "#cancel_call", function() { 
//   video_room.CancelCall().then();
//   // jr.janus.destroy()
//   //
// })

$(document).on("click", "#screen_share", function() { 
  video_room.startScreenCapture();
  $('.videocamera.option-buttons').attr("style", "display: block !important");
  $('.screen-share.option-buttons').hide();
})

$(document).on("click", "#video_share", function() { 
  video_room.VideoShare(); 
  $('.screen-share.option-buttons').show(); 
  $('.videocamera.option-buttons').attr("style", "display: none !important");

})

$(document).on("click", "#microphone", function() { 
  if(!$(this).hasClass('muted')){
    video_room.Mute();
    $(this).addClass('muted');
  }
  else{
    video_room.UnMute();
    $(this).removeClass('muted');
  }
});

