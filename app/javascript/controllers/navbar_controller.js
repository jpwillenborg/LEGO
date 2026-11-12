import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "icon", "button"]

  connect() {
    this.isOpen = false
    this.previousOverflow = ""
    this.handleKeyDown = this.handleKeyDown.bind(this)
    this.handleResize = this.handleResize.bind(this)
  }

  disconnect() {
    this.close()
  }

  toggle() {
    this.isOpen ? this.close() : this.open()
  }

  open() {
    if (this.isOpen) return
    this.isOpen = true

    this.previousOverflow = document.body.style.overflow
    document.body.style.overflow = "hidden"

    this.menuTarget.classList.remove("hidden")
    this.menuTarget.classList.add("flex")

    this.iconTarget.textContent = "✕"
    this.iconTarget.classList.remove("text-[#a0aec0]", "opacity-85")
    this.iconTarget.classList.add("text-[#00e5ff]", "opacity-100")

    this.buttonTarget.setAttribute("aria-expanded", "true")

    window.addEventListener("keydown", this.handleKeyDown)
    window.addEventListener("resize", this.handleResize)
  }

  close() {
    if (!this.isOpen) return
    this.isOpen = false

    document.body.style.overflow = this.previousOverflow || ""

    this.menuTarget.classList.add("hidden")
    this.menuTarget.classList.remove("flex")

    this.iconTarget.textContent = "☰"
    this.iconTarget.classList.remove("text-[#00e5ff]", "opacity-100")
    this.iconTarget.classList.add("text-[#a0aec0]", "opacity-85")

    this.buttonTarget.setAttribute("aria-expanded", "false")
    this.buttonTarget.blur()

    window.removeEventListener("keydown", this.handleKeyDown)
    window.removeEventListener("resize", this.handleResize)
  }

  handleKeyDown(event) {
    if (event.key === "Escape") this.close()
  }

  handleResize() {
    if (window.matchMedia("(min-width: 1040px)").matches) this.close()
  }
}
