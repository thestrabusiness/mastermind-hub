import sinon from "sinon";

window.mockTime = (unixTime) => {
  console.log(`Mocking browser time: ${unixTime}`);
  window.clock = sinon.useFakeTimers(unixTime);
};
