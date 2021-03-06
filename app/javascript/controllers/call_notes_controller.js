import { Controller } from "stimulus";
import consumer from "../channels/consumer";

export default class extends Controller {
  static targets = ["list", "textarea"];

  connect() {
    const controller = this;
    const container = this.element;
    const callId = container.getAttribute("data-call-id");
    this.currentUserId = parseInt(
      container.getAttribute("data-current-user-id")
    );

    this.subscription = consumer.subscriptions.create(
      {
        channel: "CallNotesChannel",
        call_id: callId,
      },
      {
        connected() {
          // Called when the subscription is ready for use on the server
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
        },

        received(data) {
          if (data.author_id !== controller.currentUserId) {
            controller.listTarget.insertAdjacentHTML("beforeend", data.html);
          }
        },
      }
    );
  }

  disconnect() {
    this.subscription.unsubscribe();
  }
}
