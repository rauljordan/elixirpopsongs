const liveChat = {
  init(socket) {
    let channel = socket.channel("live_chat:lobby", {});
    channel.join()
      .receive("ok", null)
      .receive("error", resp => { console.log("Unable to join", resp) })
  
    this.listenForChats(channel)
  },
  listenForChats(channel) {
    document.getElementById('chat-form').addEventListener('submit', function(e) {
      e.preventDefault()
      let userName = document.getElementById('chat-user-name').value
      let userMsg = document.getElementById('chat-user-msg').value

      channel.push('shout', {name: userName, body: userMsg})
      document.getElementById('chat-user-name').value = ''
      document.getElementById('chat-user-msg').value = ''
    })

    channel.on('shout', payload => {
      let chatBox = document.querySelector('#chat-box')
      let msgBlock = document.createElement('p')
      msgBlock.insertAdjacentHTML('beforeend', `${payload.name}: ${payload.body}`)
      chatBox.appendChild(msgBlock)
    })
  }
};

export default liveChat;