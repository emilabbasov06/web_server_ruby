# Emil's Ruby HTTP Server

A lightweight HTTP server built **from scratch in Ruby**.  
This project was created as a personal learning exercise to understand how web servers, routing, and HTTP requests work at a low level.

---

## 🚀 Project Overview

- Built using **pure Ruby** with the standard `socket` library.
- Serves **HTML, CSS, and JS** files from a `tmp/www` folder.
- Includes a **routing system** to map URL paths to specific HTML files.
- Handles **404 Not Found** pages for missing files.
- Runs continuously until stopped with `Ctrl+C`.
- Aims to give hands-on experience in **HTTP, routing, and server design** without using Rails or other frameworks.

---

## 📂 Features (Current)

- Serve static files (HTML, CSS, JS) from `tmp/www`.
- Routing system to serve different pages (e.g., `/` → `index.html`, `/blogs` → `blogs.html`).
- Automatic 404 handling for unknown paths.
- Lightweight and easy to read Ruby code for educational purposes.
- Fully functional basic HTTP server with proper headers and content types.

---

## 🛠 Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/web_server_ruby.git
cd web_server_ruby
