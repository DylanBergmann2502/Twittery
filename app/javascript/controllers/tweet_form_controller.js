import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tweet-form"
export default class extends Controller {
  connect() {
    this.element.addEventListener('submit', ()=> {
      document.getElementById('close-modal-btn').click();
    });
  }
  reset() {
    this.element.reset();
  }
}
