import consumer from "./consumer"


consumer.subscriptions.create("TimerChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const timerPage = document.querySelector(".timer-page");
    // Called when there's incoming data on the websocket for this channel
    if (timerPage) {
      location.reload();
    }
  }
});
