import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = ['list', 'textarea']

  connect() {
    const callNotesController = this;
    const notesContainer = this.element;
    const callId = notesContainer.getAttribute('data-call-id');
    this.currentUserId = parseInt(notesContainer.getAttribute('data-current-user-id'));

    this.subscription = consumer.subscriptions.create({
        channel: "CallNotesChannel",
        call_id: callId, 
      }, {

      connected() {
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(message) {
        if (message.author_id !== this.currentUserId) {
          callNotesController.appendNewMessage(message)
        }
      }
    });
  }

  disconnect() {
    this.subscription.unsubscribe();
  }

  appendNewMessage(message) { 
    const newMessageNode = document.createElement("div")
    newMessageNode.className = "list-item";

    const textNode = document.createTextNode(`${message.author} ${message.body}`)
    newMessageNode.appendChild(textNode)

    this.listTarget.appendChild(newMessageNode);
  }
}
