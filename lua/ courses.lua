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
    local url = "http://localhost:8080/courses"
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