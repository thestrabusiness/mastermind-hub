document.addEventListener("turbolinks:load", () => {
  const timer = document.querySelector("#timer");

  if (timer) {
    updateTimer(timer);
  }
})

const updateTimer = (timer) => {
  if (window.myInterval) { 
    window.clearInterval(window.myInterval)
  }

  const endTime = new Date(timer.getAttribute("data-timer-end")).getTime();
  const timerSound = document.getElementById("timer_alert")
  timerSound.volume = 0.6;

  window.myInterval = setInterval(() => {
    const now = new Date().getTime()
    const distance = endTime - now;
    // const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((distance % (1000 * 60)) / 1000);

    timer.innerHTML = `${minutes}m ${seconds}s`;

    if (distance >= 0 && distance <= 500 && timerSound.paused) {
      timerSound.play();
    }

    if (distance < 0) {
      window.clearInterval(window.myInterval);
      timer.innerHTML = "TIMES UP";
    }
  })
}

export {updateTimer};
