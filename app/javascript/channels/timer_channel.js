import consumer from "./consumer"

consumer.subscriptions.create("TimerChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const timer = document.querySelector(".timer");
    // Called when there's incoming data on the websocket for this channel
    if (timer) {
      location.reload();
    }
  }
});
