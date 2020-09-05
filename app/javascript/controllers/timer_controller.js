import { Controller } from "stimulus";
import consumer from "../channels/consumer";

const FIVE_MINUTES = 1000 * 60 * 5;

export default class extends Controller {
  static targets = ["alert", "countdown", "details"];

  initialize() {
    this.alertTarget.volume = 0.4;
  }

  connect() {
    Notification.requestPermission();

    let timerController = this;
    this.timerContainer = this.element;
    this.callId = this.timerContainer.getAttribute("data-call-id");

    if (this.hasCountdownTarget) {
      this.updateTimer();
    }

    this.subscription = consumer.subscriptions.create(
      {
        channel: "TimerChannel",
        call_id: this.callId,
      },
      {
        connected() {
          // Called when the subscription is ready for use on the server
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
        },

        received(data) {
          timerController.detailsTarget.innerHTML = data.html;
          timerController.updateTimer();
        },
      }
    );
  }

  disconnect() {
    this.subscription.unsubscribe();
    if (window.timerInterval) {
      window.clearInterval(window.timerInterval);
    }
  }

  updateTimer() {
    this.clearTimer();

    const timerEndData = this.countdownTarget.getAttribute("data-timer-end");
    const timerUserName = this.countdownTarget.getAttribute("data-timer-name");
    const endTime = new Date(timerEndData).getTime();

    this.setFiveMinuteWarning(endTime, timerUserName);
    this.setTimerInterval(endTime);
  }

  setFiveMinuteWarning(endTime, userName) {
    if (this.moreThanFiveMinutesLeft(endTime) && Notification.permission == "granted") {
      const fiveMinuteMark = this.getFiveMinuteMark(endTime);

      setTimeout(() => {
        const body = `Heads up! ${userName} has 5 minutes left`;
        new Notification("5 minutes left", { body });
      }, fiveMinuteMark );
    }
  }

  setTimerInterval(endTime) {
    window.timerInterval = setInterval(() => {
      const timeLeft = this.getTimeLeft(endTime);
      const minutes = this.timeLeftMinutes(timeLeft);
      const seconds = this.timeLeftSeconds(timeLeft);

      this.countdownTarget.innerHTML = `${minutes}m ${seconds}s`;

      if (timeLeft >= 0 && timeLeft <= 500 && this.alertTarget.paused) {
        this.alertTarget.play();
      }

      if (timeLeft < 0) {
        this.clearTimer();
        this.countdownTarget.innerHTML = "TIMES UP";
      }
    });
  }

  moreThanFiveMinutesLeft(endTime) {
    return this.getTimeLeft(endTime) > FIVE_MINUTES;
  }

  getTimeLeft(endTime) {
    const now = new Date().getTime();
    return endTime - now;
  }

  getFiveMinuteMark(endTime) {
    const now = new Date().getTime();
    return (endTime - FIVE_MINUTES) - now;
  }

  timeLeftMinutes(timeLeft) {
    return Math.floor((timeLeft % (1000 * 60 * 60)) / (1000 * 60));
  }

  timeLeftSeconds(timeLeft) {
    return Math.floor((timeLeft % (1000 * 60)) / 1000);
  }

  clearTimer() {
    if (window.timerInterval) {
      window.clearInterval(window.timerInterval);
    }
  }
}
