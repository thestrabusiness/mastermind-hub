import { Controller } from "stimulus";
import consumer from "../channels/consumer";

export default class extends Controller {
  static targets = ["emptyMessage", "commitmentList", "commitment", "icon"];

  connect() {
    this.container = this.element;
    this.commitmentCallId = this.container.getAttribute(
      "data-commitment-call-id"
    );
    this.callId = this.container.getAttribute("data-call-id");
    this.currentUserId = parseInt(
      this.container.getAttribute("data-current-user-id")
    );
    this.subscriptions = [];

    this.subscribeToCommitmentCreation();

    if (this.commitmentCallId) {
      this.subscribeToConfirmations();
    }
  }

  disconnect() {
    this.subscriptions.forEach((sub) => {
      sub.unsubscribe();
    });
  }

  subscribeToConfirmations() {
    let controller = this;
    this.subscriptions.push(
      consumer.subscriptions.create(
        {
          channel: "CommitmentConfirmationsChannel",
          call_id: this.commitmentCallId,
        },
        {
          connected() {
            // Called when the subscription is ready for use on the server
          },

          disconnected() {
            // Called when the subscription has been terminated by the server
          },

          received(data) {
            controller.iconTargets.forEach((element) => {
              if (element.getAttribute("data-id") == data.commitment_id) {
                element.innerHTML = data.html;
              }
            });
          },
        }
      )
    );
  }

  subscribeToCommitmentCreation() {
    let controller = this;
    this.subscriptions.push(
      consumer.subscriptions.create(
        {
          channel: "CallCommitmentsChannel",
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
            if (controller.hasEmptyMessageTarget) {
              controller.emptyMessageTarget.remove();
            }

            controller.commitmentListTargets.forEach((element) => {
              if (element.id && data.author_id !== controller.currentUserId) {
                element.insertAdjacentHTML("beforeend", data.html);
              }
            });
          },
        }
      )
    );
  }
}
