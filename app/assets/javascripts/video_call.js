var RECPLAY_STATE_NONE = 0;
var PLUBLISHING_OWN_FEED = 1;
var USER_MEADIA = 2;
var USER_MEADIA_CAPTURE_SCREEN = 3;
var ATTACH_FEED = 3;

class JanusCall {

  /* ---------------------------------------------------------------------- */
  
  /*
     - el_video (html element): The <video> element into which we render the video stream.
     - on_success:              Called when the recordplay plugin was created.
     - on_recording_started:    Called when the recording started.
     - on_recording_stopped:    Called when the recording stopped. 
  */
  constructor(opt) {
    this.opt = opt;
    this.ctx = null;
    this.handle = null;
    this.state = RECPLAY_STATE_NONE;
    this.stream = null;
    this.offer = null;
    this.room = null;
    this.medias = true;
    this.capture = "screen";
  }

  async init(janusContext) {

    this.ctx = janusContext;
    if (!this.ctx) {
      throw new Error("Given JanusContext is invalid.");
    }

    this.ctx.janus.attach({
      plugin: "janus.plugin.videocall",
      success: (pluginHandle) => { this.onSuccess(pluginHandle); },
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

  /* ---------------------------------------------------------------------- */



  async doHangup(resolve){
    this.handle.send({
      message: {
        request: "hangup"
      }
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


  async makeCalle(callee){
    this.callee = callee;
    this.medias = { video: true, audioSend: true };
    this.offer = await this.createOffer();
    this.handle.send({
      "message": {
        "request": "call",
        "username": this.callee,
      },
      "jsep": this.offer
    });      
  }




  async registerUsername(username){
    this.username = username; 
    var register = { "request": "register", "username": username };
    this.handle.send({"message": register});
  }

  async startScreenCapture(){
    this.capture = "screen";
    this.medias = { video: this.capture, audioSend: true, videoRecv: false };
    this.offer = await this.createOffer();
  }

  async newRemoteFeed(offer, jsep){
    await AttachJanus_remote(offer, jsep); 
  }
  /* ---------------------------------------------------------------------- */
  
  onSuccess(pluginHandle) {
    this.handle = pluginHandle;
    Janus.log("[caller] Plugin attached! (" + this.handle.getPlugin() + ", id=" + this.handle.getId() + ")");
    this.opt.on_success(); 
    this.registerUsername($('#user').val());    
  }
  
  onMessage(msg, jsep) {
    Janus.debug(" ::: Got a message :::");
    Janus.debug(msg);
    var result = msg["result"];
    // Janus.debug("Event: " + event);  
    if(result != undefined && result != null) {
      var event = result["event"];
      // alert(event);
      if(event === 'registered'){
        Janus.log("Registered...");
      }
      else if(event === 'calling'){
        Janus.log("Waiting for the peer to answer...");
        alert("Waiting for the peer to answer...");
      }
      else if(event === 'incomingcall'){
        Janus.log("Incoming call from " + result["username"] + "!");
        this.caller = result["username"];        
        if (confirm("Incoming call::Answer ?") == true) {
          var incoming = null;
          var handle = this.handle;
          this.handle.createAnswer({
            jsep: jsep,
            media: { data: true },  // Let's negotiate data channels as well
            simulcast: false,
            success: function(jsep) {
              Janus.debug("Got SDP!");
              Janus.debug(jsep);
              var body = { "request": "accept" };
              handle.send({"message": body, "jsep": jsep});
            },
            error: function(error) {
              Janus.error("WebRTC error:", error);
              alert("WebRTC error... " + JSON.stringify(error));
            }
          }); 
          //this.newRemoteFeed(handle, jsep);         
        } else {
          this.doHangup();
        }
      }  
      else if(event === 'accepted'){
        //alert(event);
        var peer = result["username"];
        if(peer === null || peer === undefined) {
          Janus.log("Call started!");
        } else {
          Janus.log(peer + " accepted the call!");
          var yourusername = peer;
        }     
        // Video call can start
        if(jsep)
          Janus.debug("Handling SDP as well...");
          Janus.debug(jsep);
          var body = { "request": "set", "audio" : true, "video" : true, "record" : true};
          this.handle.send({"message": body});           
          this.handle.handleRemoteJsep({jsep: jsep}); 
          $('#make_call').hide();
          $('#call_hangup').show();   

      }  
      else if(event === 'update'){
        // An 'update' event may be used to provide renegotiation attempts
        if(jsep) {
          if(jsep.type === "answer") {
            this.handle.handleRemoteJsep({jsep: jsep});
          } else {
            var handle = this.handle;
            this.handle.createAnswer(
              {
                jsep: jsep,
                // media: { video: capture, audioSend: true, videoRecv: false},
                media: { data: true },  // Let's negotiate data channels as well
                success: function(jsep) {
                  Janus.debug("Got SDP!");
                  Janus.debug(jsep);
                  var body = { "request": "set" };
                  handle.send({"message": body, "jsep": jsep});
                },
                error: function(error) {
                  Janus.error("WebRTC error:", error);
                  bootbox.alert("WebRTC error... " + JSON.stringify(error));
                }
              });
          }
        }
      }
      else if(event === 'hangup'){
        this.handle.hangup();
      }                              
    }
    else {
      var error = msg["error"];
      alert(error);
      $('.video-establishing-container').hide();
      $('.video-ready-to-call-container').show();
      $('.local-stream video').hide();
      if(error.indexOf("already taken") > 0) {
        alert('already taken user name');
      }
      if(error.indexOf("doesn't exist") > 0) {
        alert('user not available');
      }
      this.handle.hangup();
    }   
    Janus.debug("[caller]  ::: Got a message :::");      
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
    $('.local-stream video').show();
    Janus.attachMediaStream($('#local-stream').get(0), stream);
    this.stream = stream;
    $("#local-stream").get(0).muted = "muted";
    $('.remote-stream-container').hide();
    var videoTracks = stream.getVideoTracks();
    if(videoTracks === null || videoTracks === undefined || videoTracks.length === 0) {
      // No webcam
      // $('.local-stream').html('No Local webcam');
    }
  }
  onRemoteStream(stream){
    Janus.attachMediaStream($('#remote-stream').get(0), stream);
    this.remote_stream = stream;
    $('.video-establishing-container').hide();
    $('.remote-stream-container').show();
    $('.option-buttons').show();
    // $("#remotevideo").get(0).muted = "muted";
    var videoTracks = stream.getVideoTracks();
    if(videoTracks === null || videoTracks === undefined || videoTracks.length === 0) {
      // No webcam
      $('.remote').html('No webcam');
    }
  }
  onDataOpen() { }
  onData() { }
  onCleanUp() { 
    $('.option-buttons').hide();
    $('.remote-stream-container').hide();
    $('.video-ready-to-call-container').show();
    $('#make_call').show();
    $('#call_hangup').hide(); 
    $('.local-stream video').hide();    
  }
  onDetached() { 
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


var AttachJanus = async function() {
  jr = new JanusContext();

  call_plugin = new JanusCall({
    el_video: document.querySelector("#my_video"),
    on_success: async () => {
      Janus.log("Plugin attached! (" + call_plugin.handle.getPlugin() + ", id=" + call_plugin.handle.getId() + ")");    
    }
  });


  try {
    try {
      await jr.init();
      await jr.attachPlugin(call_plugin);
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



// $(document).on("click", "#register_user", function() { 
//   call_plugin.registerUsername($('#user').val());
// });


// $(document).on("click", "#make_call", function() { 
//   $('.video-ready-to-call-container').hide();
//   $('.video-establishing-container').show();
//   call_plugin.makeCalle($('#callee').val());
// })

// $(document).on("click", "#call_hangup", function() { 
//   call_plugin.doHangup().then();
//   // jr.janus.destroy()
//   //
// })

// $(document).on("click", "#screen_share", function() { 
//   call_plugin.startScreenCapture();
// })


