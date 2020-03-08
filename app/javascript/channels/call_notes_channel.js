import consumer from "./consumer"

document.addEventListener("turbolinks:load", ()=>{
    const notesContainer = document.querySelector('#notes_container');

    if (notesContainer) {
      consumer.subscriptions.create({
          channel: "CallNotesChannel",
          call_id: notesContainer.getAttribute('data-call-id'),
        }, {

        connected() {
          // Called when the subscription is ready for use on the server
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
        },

        received(data) {
          const node = document.createElement("div")
          node.className = "list-item";
          const textNode = document.createTextNode(`${data.author} ${data.body}`)
          node.appendChild(textNode)
          notesContainer.appendChild(node);
        }
      });
    }
})
