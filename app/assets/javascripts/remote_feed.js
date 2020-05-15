var feeds = [];

class RemoteFeed {
  constructor(opt) {
    this.opt = opt;
    this.ctx = null;
    this.remoteFeed = null;
    this.state = RECPLAY_STATE_NONE;
    this.stream = null;
    this.offer = null;
    this.room = opt.room;
    this.media = null;
  }

  async init(janusContext) {

    this.ctx = janusContext;
    if (!this.ctx) {
      throw new Error("Given JanusContext is invalid.");
    }

    this.ctx.janus.attach({
      plugin: "janus.plugin.videoroom",
      success: (pluginremoteFeed) => { this.onSuccess(pluginremoteFeed); },
      error: (err) => { this.onError(err); },
      consentDialog: (on) => { this.onConsentDialog(on); },
      webrtcState: (isOk, msg) => { this.onWebRtcState(isOk, msg); },
      iceState: (state) => { this.onIceState(state); },
      mediaState: () => { this.onMediaState(); },
      slowLink: () => { this.onSlowLink(); },
      onmessage: (msg, jsep) => { this.onMessage(msg, jsep); },
      onlocalstream: (stream) => { this.onLocalStream(stream); }, 
      onremotestream: (stream) => { this.onRemoteStream(stream); }, 
      ondataopen: () => { this.onDataOpen(); },
      ondata: () => { this.onData(); },
      oncleanup: () => { this.onCleanUp(); },
      detached: () => { this.onDetached(); },
    });

    return true;
  }

 
  async JoinRoom(){
    var listen = { "request": "join", "room": this.room, "ptype": "subscriber", "feed": this.opt.id, "pin": "xxxxxx" };
    this.remoteFeed.videoCodec = this.video;
    this.remoteFeed.send({"message": listen});     
  }

  /* ---------------------------------------------------------------------- */
  

  
  onSuccess(pluginremoteFeed) {
    this.remoteFeed = pluginremoteFeed;
    this.room = this.opt.room;
    this.JoinRoom();
    this.opt.on_success();     
  }
  
  async onMessage(msg, jsep) {
    Janus.debug(" ::: Got a message (Remote subscriber) :::");
    Janus.debug(msg);
    var event = msg["videoroom"];
    Janus.debug("Event: " + event);  
    if(msg["error"] !== undefined && msg["error"] !== null) {
      alert(msg["error"]);
    }
    else if(event != undefined && event != null) {
      if(event === "attached") {
        // Subscriber created and attached
        //alert('new-one');
        for(var i=1;i<2;i++) {
          if(feeds[i] === undefined || feeds[i] === null) {
            feeds[i] = this.remoteFeed;
            this.remoteFeed.rfindex = i;
            break;
          }
        }  
        this.remoteFeed.rfid = msg["id"];
        this.remoteFeed.rfdisplay = msg["display"];     
        Janus.log("Successfully attached to feed " + this.remoteFeed.rfid + " (" + this.remoteFeed.rfdisplay + ") in room " + msg["room"]);         
      }
      else if(event === "event") {}
      else { 
        // What has just happened?
      }
    }
    if(jsep !== undefined && jsep !== null) {
      Janus.debug("Handling SDP well...");
      Janus.debug(jsep);     

      var remoteFeed = this.remoteFeed;
      this.remoteFeed.createAnswer(
        {
          jsep: jsep,
          media: { audioSend: false, videoSend: false },  // We want recvonly audio/video
          success: function(jsep) {
            Janus.debug("Got SDP!");
            Janus.debug(jsep);
            var body = { "request": "start", "room": this.room };
            remoteFeed.send({"message": body, "jsep": jsep});
          },
          error: function(error) {
            Janus.error("WebRTC error:", error);
            alert("WebRTC error... " + JSON.stringify(error));
          }
        });
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
  onRemoteStream(stream) { 
    Janus.attachMediaStream($('#remote-stream').get(0), stream);
    this.stream = stream;
    // $("#remotevideo").get(0).muted = "muted";
    var videoTracks = stream.getVideoTracks();
    if(videoTracks === null || videoTracks === undefined || videoTracks.length === 0) {
      // No webcam
      $('.remote-stream-container').html('No webcam Found');
    }
  }
  onDataOpen() { }
  onData() { }
  onCleanUp() { }
  onDetached() { }
};



var AttachJanus_remote = async function(id, display, audio, video, room) {
  remotejr = new JanusContext();

  remote_feed = new RemoteFeed({
    el_video: document.querySelector("#remotevideo"),
    id: id,
    display: display,
    audio: audio,
    video: video,
    room: room,
    on_success: async () => {
      //Janus.log("Remote Plugin attached! (" + remote_feed.remoteFeed.getPlugin() + ", id=" + remote_feed.remoteFeed.getId() + ")");    
    }
  });


  try {
    try {
      await remotejr.init();
      await remotejr.attachPlugin(remote_feed);
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

// AttachJanus_remote();
