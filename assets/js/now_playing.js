let NowPlaying = {
  audio: new Audio(),
  playing: false,
  init(socket) {
    let channel = socket.channel('now_playing:lobby', {});
    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })
  
    this.listenForTrack(channel);
  },
  listenForTrack(channel) {
    document.getElementById('play-btn').addEventListener('click', _ => {
      if (this.audio.src === '') {
        channel.push('ping', {play: true})
          .receive('ok', ({
            slug,
            title,
            artist,
          }) => {
            this.audio.src = `https://citypopsongs.nyc3.cdn.digitaloceanspaces.com/mp3/${slug}.mp3`;
            this.audio.play();
            document.getElementById('play-btn-icon').textContent = 'pause';
            document.getElementById('player-title').textContent = title;
            document.getElementById('player-artist').textContent = artist;
            document.getElementById('player-img').style.backgroundImage = `url(https://citypopsongs.nyc3.cdn.digitaloceanspaces.com/img/${slug}.jpg)`
            this.playing = true;
          });
      } else {
        if (this.playing) {
          this.audio.pause();
          document.getElementById('play-btn-icon').textContent = 'play_arrow';
          this.playing = false;
        } else {
          this.audio.play();
          document.getElementById('play-btn-icon').textContent = 'pause';
          this.playing = true;
        }
      }
    });
  }
};

export default NowPlaying;