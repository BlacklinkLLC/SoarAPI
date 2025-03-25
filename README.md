# **Blacklink SoarAPI** 🚀

Welcome to **Blacklink SoarAPI**, the powerful API for creating custom third-party clients for Blacklink Education’s **.edu** platform. SoarAPI allows you to seamlessly interact with Blacklink’s backend, providing data and features that can be used to create your own applications for educational enhancement.

This repository includes everything you need to get started building your own client using Lua, including the Lua-based **Blacklink Soar Client**, which is the default client for **.edu**.

---

## **Table of Contents** 📚
- [Getting Started](#getting-started)
- [Authentication](#authentication)
- [API Endpoints](#api-endpoints)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

---

## **Getting Started** 🛠️

To use the **Blacklink SoarAPI**, you need to set up a Lua environment. You can get started by installing Lua and the required libraries:

1. Install [Lua](https://www.lua.org/download.html).
2. Install LuaSocket (for HTTP requests):
    ```bash
    luarocks install luasocket
    ```
3. Install [dkjson](https://dkolf.de/src/dkjson-lua.fsl) for JSON handling:
    ```bash
    luarocks install dkjson
    ```

---

## **Authentication** 🔐

To interact with the API, you will need to authenticate. This typically involves providing an API key or access token. For this demo, authentication is not implemented, but it's easy to add headers or other authentication methods to the requests. Ensure you modify the `http.request` function to include your authorization details.

---

## **API Endpoints** 📡

### `/courses`
Fetches a list of available courses from the Blacklink backend.

- **Method**: `GET`
- **Response**: JSON list of courses with the following fields:
  - `title`: Name of the course
  - `description`: A brief description of the course

Example response:

```json
[
  {
    "title": "Math 101",
    "description": "Introduction to basic mathematics."
  },
  {
    "title": "Science 101",
    "description": "An introduction to the scientific method and basic biology."
  }
]
```

## Examples 💻

Here is an example of how to use the Blacklink Soar Client in Lua to fetch and display courses from the .edu platform.

``` lua
local http = require("socket.http")
local json = require("dkjson")

-- HTML and CSS for the client
local html = [[
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blacklink .edu</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #121212;
            color: #e0e0e0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            flex-direction: column;
        }

        .container {
            text-align: center;
            max-width: 600px;
            width: 100%;
        }

        h1 {
            color: #4FC3F7;
        }

        #data {
            margin-top: 20px;
            padding: 10px;
            background-color: #1e1e1e;
            border-radius: 6px;
            display: inline-block;
            color: #fff;
        }

        .course-list {
            margin-top: 20px;
            padding: 10px;
            background-color: #1e1e1e;
            border-radius: 6px;
            display: block;
            color: #fff;
            text-align: left;
        }

        .course-item {
            margin-bottom: 10px;
            padding: 5px;
            border: 1px solid #4FC3F7;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to .edu!</h1>
        <div id="data">Loading...</div>
        
        <div class="course-list" id="course-list">
            <h3>Courses:</h3>
            <ul id="courses"></ul>
        </div>
    </div>
</body>
</html>
]]

-- Function to fetch courses from Go backend using Lua
function fetch_courses()
    local url = "http://api.blacklink.net:8080/courses"
    local response, status = http.request(url)

    if status ~= 200 then
        print("Error fetching courses: " .. status)
        return
    end

    local courses = json.decode(response)
    return courses
end

-- Function to render the courses in HTML format
function render_courses(courses)
    if not courses or #courses == 0 then
        print("No courses available.")
        return
    end

    local course_list_html = ""
    for _, course in ipairs(courses) do
        course_list_html = course_list_html .. string.format("<li class=\"course-item\"><strong>%s</strong>: %s</li>", course.title, course.description)
    end

    -- You can dynamically replace the content in your HTML file
    local updated_html = string.gsub(html, '<ul id="courses"></ul>', '<ul id="courses">' .. course_list_html .. '</ul>')

    -- Save the updated HTML with course list
    local file = io.open("index.html", "w")
    file:write(updated_html)
    file:close()

    print("HTML file created with courses. Open index.html to test.")
end

-- Main function to fetch and render courses
function main()
    local courses = fetch_courses()
    render_courses(courses)
end

main()
```
This script uses the Lua socket.http module to fetch data from Blacklink’s backend API and dkjson to parse the JSON response. It then generates an HTML file (index.html) with the list of available courses.

### Contributing 🤝

We welcome contributions from the community! If you have any improvements, bug fixes, or new features to propose, please open a pull request.

Steps to contribute:
	1.	Fork the repository.
	2.	Create a new branch (git checkout -b feature-name).
	3.	Make your changes and commit (git commit -am 'Add new feature').
	4.	Push to the branch (git push origin feature-name).
	5.	Open a pull request.

###License 📜

This project is licensed under the MIT License

###Contact 📬

For questions, suggestions, or issues, feel free to open an issue in the repository or contact us at contact@blacklink.net.

####Happy coding! 😎🚀
