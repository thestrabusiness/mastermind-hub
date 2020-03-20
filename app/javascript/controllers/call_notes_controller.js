import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = ['list', 'textarea']

  connect() {
    const callNotesController = this;
    const notesContainer = this.element;
    const callId = notesContainer.getAttribute('data-call-id');

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

      received(data) {
        callNotesController.appendNewMessage(data)
        callNotesController.resetNoteForm();
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

  resetNoteForm() {
    this.textareaTarget.value = "";
  }
}
