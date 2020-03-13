import consumer from "./consumer"
import { updateTimer } from "../timer";

document.addEventListener("turbolinks:load", () => {
  let timerContainer = document.querySelector("#timer_container");

  if (timerContainer) {
    consumer.subscriptions.create({
        channel: "TimerChannel",
        call_id: timerContainer.getAttribute('data-call-id'),
      }, {

      connected() {
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        timerContainer.innerHTML = data.html;
        const newTimer = document.querySelector("#timer")
        updateTimer(newTimer)
      }
    });
  }
})

