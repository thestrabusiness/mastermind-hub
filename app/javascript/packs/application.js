// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
//
//

document.addEventListener("turbolinks:load", () => {
  const timer = document.querySelector("#timer");

  if (timer) {
    const endTime = new Date(timer.getAttribute("data-timer-end")).getTime();
    const timerSound = document.getElementById("timer_alert")
    timerSound.volume = 0.6;

    const interval = setInterval(()=>{
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
        clearInterval(interval);
        timer.innerHTML = "TIMES UP";
      }
    })
  }
})
