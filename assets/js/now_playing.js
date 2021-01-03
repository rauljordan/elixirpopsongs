const nowPlaying = {
  audio: new Audio(),
  playing: false,
  init(socket) {
    this.audio.autoplay = true;
    let channel = socket.channel("now_playing:lobby", {});
    channel.join()
      .receive("ok", null)
      .receive("error", resp => { console.log("Unable to join", resp) })
  
    this.checkListenRadio(channel);
    this.listenForTrack(channel);
  },
  checkListenRadio(channel) {
    document.getElementById("listen-btn").addEventListener("click", _ => {
      document.getElementById("entry-overlay").style.display = "none";
      document.getElementById("radio").style.display = "flex";
      this.playTrack(channel);
    });
  },
  listenForTrack(channel) {
    document.getElementById("play-btn").addEventListener("click", _ => {
      if (this.audio.src === "") {
        this.playTrack(channel);
      } else {
        if (this.playing) {
          this.audio.muted = true;
          document.getElementById("play-btn-icon").textContent = "volume_up";
          this.playing = false;
        } else {
          this.audio.muted = false;
          document.getElementById("play-btn-icon").textContent = "volume_off";
          this.playing = true;
        }
      }
    });
  },
  playTrack(channel) {
    channel.push("ping", {play: true})
      .receive("ok", ({
        slug,
        title,
        artist,
        seconds,
        listens,
        starting_at,
        ending_at,
      }) => {
        this.audio.muted = true;

        const timeNow = Math.floor(Date.now() / 1000);
        const elapsed = timeNow - starting_at;
        const playNextSong = ending_at - timeNow;

        // Play the next song once it is time.
        setTimeout(() => {
          this.playTrack(channel);
        }, playNextSong * 1000);

        this.audio.src = `https://citypopsongs.nyc3.digitaloceanspaces.com/mp3/${slug}.mp3`;
        this.audio.currentTime = elapsed;
        this.audio.muted = false;
        this.audio.play();

        this.audio.ontimeupdate = function(event) {
          const percent = (this.currentTime / this.duration) * 100;
          document.getElementById("player-progress").style.width = `${percent}%`;
          document.getElementById("player-elapsed").textContent = fmtMSS(Math.floor(this.currentTime));
          document.getElementById("player-total").textContent = fmtMSS(Math.floor(this.duration));
        };

        document.getElementById("play-btn-icon").textContent = "volume_off";
        document.getElementById("player-title").textContent = title;
        document.getElementById("player-artist").textContent = artist;
        document.getElementById("player-total-listens").textContent = `${listens} total listens`
        document.getElementById("player-img").style.backgroundImage = `url(https://citypopsongs.nyc3.digitaloceanspaces.com/img/${slug}.jpg)`
        this.playing = true;
      });
  },
  fmtMSS(s) {
    return(s-(s%=60))/60+(9<s?':':':0')+s;
  }
};

function fmtMSS(s) {
  return(s-(s%=60))/60+(9<s?':':':0')+s;
}

export default nowPlaying;