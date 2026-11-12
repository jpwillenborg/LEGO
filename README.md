# LEGO® Collection Tracker

An interactive full-stack web application featuring a monolithic Ruby on Rails architecture, relational Active Record caching, external Rebrickable API data ingestion, and real-time Hotwire (Turbo Streams) DOM updates. This system functions as a portfolio engineering demonstration designed to track set completion and part verification workflows without full-page browser reloads.

🔗 **Live Production Deployment:** [https://lego.jpwillenborg.com](https://lego.jpwillenborg.com)

🏗️ System Architecture & Engineering
Unlike decoupled SPA + REST API builds, this application utilizes a unified monolithic architecture powered by Ruby on Rails and Hotwire:

* **Monolithic Rails & Hotwire Engine:** Built on Ruby 3.3 and Ruby on Rails, rendering semantic server-side HTML templates enhanced with Turbo Drive and Turbo Streams for sub-second partial page updates. Internal layouts rely on Tailwind CSS for fluid, mobile-first breakpoints and custom dark-mode UI surfaces.
* **Rebrickable API Integration & Local Caching Layer:** Queries the external Rebrickable REST API on initial set lookups, normalizes official set numbers automatically, and persists set manifests, part catalogs, and junction quantities into relational database tables so subsequent lookups load instantaneously without redundant API calls.

⚡ Core Technical Features
* **Zero-Reload Turbo Stream Micro-Interactions:** Piece increment/decrement actions (`+` / `−`), set switching, set deletions, and lazy-loaded pagination (`Load More Pieces`) execute via targeted Turbo Stream responses that surgically patch individual part cards and progress bars without full-page refreshes.
* **Stateless Visitor Session Isolation:** Stores active set selections and per-piece inventory counts inside encrypted browser session cookies (`session[:sandbox_inventory]`), isolating each visitor's tracking progress so concurrent reviewers never overwrite one another's state while sharing the cached set catalog.
* **Automated Database Epoch Synchronization:** Stamps a deployment epoch token during database seeding so fresh deployments or resets automatically reconcile stale browser session cookies on a visitor's next request.
* **High-Resolution Set Lightbox & Featured Presets:** Pre-caches flagship sets (`42207` Ferrari SF-24 F1 Car, `10309` Succulents, and `21063` Neuschwanstein Castle) on initialization and provides an interactive lightbox modal for inspecting set artwork.

🛠️ Stack Configuration & Primitives
* **Backend Framework:** Ruby 3.3.13, Ruby on Rails, Active Record ORM
* **Frontend & Real-Time UI:** Hotwire (Turbo Streams), Tailwind CSS, Importmap JS
* **External Data Integration:** Rebrickable REST API (`Net::HTTP` / JSON manifest parser)
* **Database / Persistence Layer:** SQLite3 Relational Storage Engine with composite unique indexes
* **Live Infrastructure Hosting:** Render Docker Web Service Container (`Puma` + `Thruster`) with custom DNS routing (`lego.jpwillenborg.com`)

---

## 💻 Local Development Setup

The application operates out of the box using **SQLite3** and automatically seeds the featured showcase sets on initialization. To explore the live production deployment, visit [https://lego.jpwillenborg.com](https://lego.jpwillenborg.com).

### 1. Prerequisites & Environment Configuration
Ensure **Ruby 3.3.13**, **Bundler**, and **SQLite3** development libraries are installed on your machine (WSL2 Ubuntu is recommended on Windows).

Clone the repository and install Ruby gem dependencies:

```bash
git clone https://github.com/jpwillenborg/LEGO.git
cd LEGO
bundle install
```

Supply your **Rebrickable API Key** either via Rails encrypted credentials (`config/master.key`) or by setting the `REBRICKABLE_API_KEY` environment variable:

```env
REBRICKABLE_API_KEY=your_rebrickable_api_key_here
```

### 2. Database Setup & Pre-Seeding
Create the SQLite database, run schema migrations, and pre-cache the three featured LEGO® sets:

```bash
bin/rails db:prepare
bin/rails db:seed
```

*(Optional)* To wipe the local database, re-seed the featured sets, and reset browser session counts back to zero at any time:

```bash
bin/rails db:reset
```

### 3. Launch the Development Server
Start the Rails web server and Tailwind CSS watcher concurrently via Foreman (`Procfile.dev`):

```bash
bin/dev
```

Open **[http://localhost:5178](http://localhost:5178)** in your browser to inspect the workspace.
