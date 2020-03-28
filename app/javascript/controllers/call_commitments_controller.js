import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = ['commitment', 'icon']

  connect() {
    let callCommitmentsController = this;
    this.container = this.element;
    this.callId = this.container.getAttribute('data-call-id')

    if (this.callId) { 
      this.subscription = consumer.subscriptions.create({
            channel: "CallCommitmentsChannel",
            call_id: this.callId,
          }, {

          connected() {
            // Called when the subscription is ready for use on the server
          },

          disconnected() {
            // Called when the subscription has been terminated by the server
          },

          received(data) {
            callCommitmentsController.iconTargets.forEach((element) => {
              if (element.getAttribute('data-id') == data.commitment_id) {
                element.innerHTML = data.html;
              }
            })
          }
        });
    }
  }

  disconnect() {
    this.subscription.unsubscribe();
  }
}
