# 🧪 hugo-tailwind-template

A ready-to-use development environment for Hugo with Tailwind CSS, built entirely in Docker — with reliable hot-reload for **content**, **layouts**, and **themes**.

No need to install Node, Hugo, or Tailwind on your machine.

## ✅ Features

- 📦 Docker-based: no local installs required
- ⚡ Hot reload works on content + layout + Tailwind style changes
- 🛠 Includes helper services to initialize or build your site
- 🕵️ Uses [hugo-watcher](https://github.com/ietxaniz/hugo-watcher) to detect changes Docker normally misses

---

## 🚀 Quick Start

1. Clone this repository
2. Run:

```sh
docker compose run init
docker compose up
```

3. Open your browser at [http://localhost:1313](http://localhost:1313)
4. Edit files in `web/` and see live changes (content, layout, and styles)

---

## 📝 example docker-compose.yml

```yaml
services:
  hugo:
    image: inigoetxaniz/hugo-tailwind-dev:0.146.6
    volumes:
      - ./web:/site
    command: hugo server --bind 0.0.0.0 --baseURL http://localhost:1313/ --noHTTPCache --appendPort=false --disableFastRender
    user: "${UID}:${GID}"
    working_dir: /site
    ports:
      - 1313:1313
  build:
    image: inigoetxaniz/hugo-tailwind-dev:0.146.6
    volumes:
      - ./web:/site
    command: hugo --baseURL https://example.com
    profiles: ["manual"]
    user: "${UID}:${GID}"
    working_dir: /site
  init:
    image: inigoetxaniz/hugo-tailwind-dev:0.146.6
    volumes:
      - ./web:/site
    command: hugo new site /site --force
    profiles: ["manual"]
    user: "${UID}:${GID}"
    working_dir: /site
  watcher:
    container_name: hugo-watcher
    image: inigoetxaniz/hugo-watcher:1.0
    volumes:
      - ./web:/site
    user: "${UID}:${GID}"
    depends_on:
      - hugo
```

---

## 📂 Folder Structure

```txt
/
├── docker-compose.yml        # Full dev + watcher setup
├── web/                      # Your Hugo project lives here
│   └── content/, layouts/, assets/, ...
```

---

## 🧑‍💻 Common Commands

### Create a new Hugo site (if starting fresh)

```sh
docker compose run init
```

### Create a new post

```sh
docker compose run --rm hugo hugo new content/my-post.md
```

### Build static site for production

```sh
docker compose run build
```

---

## 🛠 Requirements

- Docker + Docker Compose
- Unix shell (Linux/macOS) or WSL on Windows
- UID/GID environment variables (if using user mapping)

---

## 📦 Images Used

- [inigoetxaniz/hugo-tailwind-dev](https://hub.docker.com/r/inigoetxaniz/hugo-tailwind-dev)
- [inigoetxaniz/hugo-watcher](https://hub.docker.com/r/inigoetxaniz/hugo-watcher)

---

Perfect — thanks for clarifying! You're using the **Hugo + Tailwind v4 integration via hugo_stats.json**, and that changes how the CSS is structured compared to classic setups.

Here's an updated **Tailwind integration section** for the `README.md`, based on your actual working config:

---

## ▶️ TailwindCSS Integration (v4)

This setup uses **Tailwind CSS v4.0** with Hugo’s built-in asset pipeline and `hugo_stats.json` to enable automatic class scanning.

### `assets/css/main.css`

```css
@import "tailwindcss";
@source "hugo_stats.json";
```

---

### `tailwind.config.js`

```js
export default {
  content: [
    "./hugo_stats.json",
    "./layouts/**/*.html",
    "./content/**/*.md",
    "./themes/**/*.{html,js}"
  ],
  theme: {
    extend: {}
  },
  plugins: []
}
```

---

### Add the following to your `hugo.toml`

```toml
[markup]
  [markup.goldmark]
    [markup.goldmark.parser]
      [markup.goldmark.parser.attribute]
        block = true

[build]
  [build.buildStats]
    enable = true

  [[build.cachebusters]]
    source = 'assets/notwatching/hugo_stats\\.json'
    target = 'css'

  [[build.cachebusters]]
    source = '(postcss|tailwind)\\.config\\.js'
    target = 'css'

[module]
  [[module.mounts]]
    source = 'assets'
    target = 'assets'

  [[module.mounts]]
    disableWatch = true
    source = 'hugo_stats.json'
    target = 'assets/notwatching/hugo_stats.json'
```

---

### In your layout (e.g. `baseof.html`)

Make sure you include the compiled CSS:

```html
{{ $css := "" }}
{{ if hugo.IsServer }}
  {{ $css = resources.Get "css/main.css" | css.TailwindCSS | minify }}
  <link rel="stylesheet" href="{{ $css.RelPermalink }}?v={{ now.Unix }}">
{{ else }}
  {{ $css = resources.Get "css/main.css" | css.TailwindCSS | minify | fingerprint }}
  <link rel="stylesheet" href="{{ $css.RelPermalink }}" integrity="{{ $css.Data.Integrity }}">
{{ end }}
```

---

## 📃 License

MIT
