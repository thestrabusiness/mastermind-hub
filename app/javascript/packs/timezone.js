import jstz from "jstz";

const setCookie = (name, value) => {
  let expires = new Date();
  expires.setTime(expires.getTime() + 24 * 60 * 60 * 1000);
  document.cookie = name + "=" + value + ";expires=" + expires.toUTCString();
};

document.addEventListener("turbolinks:load", () => {
  const timezone = jstz.determine();
  setCookie("timezone", timezone.name());
});
