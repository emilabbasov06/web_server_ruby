# Emil's Ruby HTTP Server

A lightweight HTTP server built **from scratch in Ruby**.  
This project is a personal learning exercise to understand how web servers, routing, HTTP requests, and basic database operations work at a low level.

---

## 🚀 Project Overview

- Built using **pure Ruby** with the standard `socket` library.  
- Serves **HTML, CSS, and JS** files from a `tmp/www` folder.  
- Includes a **routing system** to map URL paths to specific HTML files.  
- Handles **404 Not Found** pages for unknown paths.  
- Includes **basic CRUD database functionality** using SQLite3 via a custom `Utils` module.  
- Runs continuously until stopped with `Ctrl+C`.  
- Perfect for hands-on experience in **HTTP, routing, server design, and database operations** without Rails or other frameworks.

---

## 📂 Routes

The server currently supports the following routes:

| Route              | Method | Description                        |
|-------------------|--------|------------------------------------|
| `/`               | GET    | Serve `index.html` (Home page)     |
| `/blogs`          | GET    | List all blogs                      |
| `/new`            | GET    | Serve form to add a new blog       |
| `/blog/:id`       | GET    | View a single blog by its ID       |
| `/blogs`          | DELETE | Delete a blog by its ID            |

> Note: `:id` is a placeholder for the numeric ID of the blog.

---

## 🛠 Installation & Running

1. Clone the repository:

```bash
git clone https://github.com/yourusername/web_server_ruby.git
cd web_server_ruby
```

2. Run the server

```bash
ruby main.rb
```

3. Open your browser and go to http://localhost:3000/ to access the server.

---

## 💾 Database Functionality

The server uses **SQLite3** as the database.

It includes a custom `Utils` module for **CRUD operations** on blogs:

- Create new blog entries  
- Read/list blogs
- Read/list single blog  
- Delete blogs  

This is implemented using pure Ruby with `sqlite3` **without an ORM**.

---

## 📖 Learning Goals

By building and using this server, you will get hands-on experience with:

- Low-level HTTP request handling  
- Socket programming in Ruby  
- Basic routing logic  
- Serving static files  
- Simple database CRUD operations using SQLite3  
- Building a lightweight server **without frameworks**