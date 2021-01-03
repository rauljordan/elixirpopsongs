let NowPlaying = {
  audio: new Audio(),
  playing: false,
  init(socket) {
    let channel = socket.channel('now_playing:lobby', {});
    channel.join()
      .receive("ok", null)
      .receive("error", resp => { console.log("Unable to join", resp) })
  
    this.listenForTrack(channel);
  },
  listenForTrack(channel) {
    this.audio.autoplay = true;
    document.getElementById('play-btn').addEventListener('click', _ => {
      if (this.audio.src === '') {
        this.playTrack(channel);
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
  },
  playTrack(channel) {
    channel.push('ping', {play: true})
      .receive('ok', ({
        slug,
        title,
        artist,
        seconds,
        starting_at,
        ending_at,
      }) => {
        this.audio.pause();

        const timeNow = Math.floor(Date.now() / 1000);
        const elapsed = timeNow - starting_at;
        const playNextSong = ending_at - timeNow;

        // Play the next song once it is time.
        setTimeout(() => {
          this.playTrack(channel);
        }, playNextSong * 1000);

        this.audio.src = `https://citypopsongs.nyc3.digitaloceanspaces.com/mp3/${slug}.mp3`;
        this.audio.currentTime = elapsed;
        this.audio.play();
        document.getElementById('play-btn-icon').textContent = 'pause';
        document.getElementById('player-title').textContent = title;
        document.getElementById('player-artist').textContent = artist;
        document.getElementById('player-img').style.backgroundImage = `url(https://citypopsongs.nyc3.digitaloceanspaces.com/img/${slug}.jpg)`
        this.playing = true;
      });
  }
};

export default NowPlaying;