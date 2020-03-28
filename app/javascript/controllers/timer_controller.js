import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = ['alert', 'countdown', 'details']

  initialize() { 
    this.alertTarget.volume = 0.4;
  }

  connect() {
    let timerController = this;
    this.timerContainer = this.element;
    this.callId = this.timerContainer.getAttribute('data-call-id')

    if (this.hasCountdownTarget) { 
      this.updateTimer();
    }

    this.subscription = consumer.subscriptions.create({
          channel: "TimerChannel",
          call_id: this.callId,
        }, {

        connected() {
          // Called when the subscription is ready for use on the server
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
        },

        received(data) {
          timerController.detailsTarget.innerHTML = data.html;
          timerController.updateTimer();
        }
      });
  }

  disconnect() { 
    this.subscription.unsubscribe();
    if (window.timerInterval) { 
      window.clearInterval(window.timerInterval)
    }
  }


  updateTimer() {
    this.clearTimer();
    const timerEndData = this.countdownTarget.getAttribute('data-timer-end');
    const endTime = new Date(timerEndData).getTime();

    window.timerInterval = setInterval(() => {
      const now = new Date().getTime()
      const distance = endTime - now;
      // const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      const seconds = Math.floor((distance % (1000 * 60)) / 1000);

      this.countdownTarget.innerHTML = `${minutes}m ${seconds}s`;

      if (distance >= 0 && distance <= 500 && this.alertTarget.paused) {
        this.alertTarget.play();
      }

      if (distance < 0) {
        this.clearTimer();
        this.countdownTarget.innerHTML = "TIMES UP";
      }
    })
  }

    clearTimer() { 
      if (window.timerInterval) { 
        window.clearInterval(window.timerInterval)
      }
    }
}