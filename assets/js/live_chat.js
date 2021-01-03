import rug from "random-username-generator";

const liveChat = {
  username: "",
  init(socket) {
    this.username = rug.generate().replace(/[0-9]/g, "").slice(0, -1).toLowerCase();
    let channel = socket.channel("live_chat:lobby", {});
    channel.join()
      .receive("ok", null)
      .receive("error", resp => { console.log("Unable to join", resp) });
  
    this.listenForChats(channel);
  },
  listenForChats(channel) {
    let chatBox = document.getElementById("chat-box");
    document.getElementById("chat-user-msg").addEventListener("focus", (e) => {
      chatBox.scroll({
        top: chatBox.scrollHeight,
        behavior: "smooth"
      });
    })

    document.getElementById("chat-form").addEventListener("submit", (e) => {
      e.preventDefault();
      let userMsg = document.getElementById("chat-user-msg").value;
      console.log(this.username);
      channel.push("shout", {name: this.username, body: userMsg});
      document.getElementById("chat-user-msg").value = "";
    })

    channel.on("shout", payload => {
      let msgBlock = document.createElement("p");
      msgBlock.className = "message text-gray-200";
      msgBlock.insertAdjacentHTML("beforeend", `<b class="text-red-400">${payload.name}:</b> ${payload.body}`);
      chatBox.appendChild(msgBlock);
      chatBox.scroll({
        top: chatBox.scrollHeight,
        behavior: "smooth"
      });
    })
  }
};

function docReady(fn) {
  // see if DOM is already available
  if (document.readyState === "complete" || document.readyState === "interactive") {
    // call on next available tick
    setTimeout(fn, 1);
  } else {
    document.addEventListener("DOMContentLoaded", fn);
  }
}    

export default liveChat;