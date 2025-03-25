local http = require("socket.http")
local json = require("dkjson")

-- HTML and CSS for the grades page
local html = [[
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blacklink .edu - Grades</title>
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

        #grades {
            margin-top: 20px;
            padding: 10px;
            background-color: #1e1e1e;
            border-radius: 6px;
            display: inline-block;
            color: #fff;
        }

        .grade-list {
            margin-top: 20px;
            padding: 10px;
            background-color: #1e1e1e;
            border-radius: 6px;
            display: block;
            color: #fff;
            text-align: left;
        }

        .grade-item {
            margin-bottom: 10px;
            padding: 5px;
            border: 1px solid #4FC3F7;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Your Grades</h1>
        <div id="grades">Loading...</div>
        
        <div class="grade-list" id="grade-list">
            <h3>Grades:</h3>
            <ul id="grades-list"></ul>
        </div>
    </div>
</body>
</html>
]]

-- Function to fetch grades from the backend using Lua
function fetch_grades()
    local url = "http://api.blacklink.net:8080/grades"
    local response, status = http.request(url)

    if status ~= 200 then
        print("Error fetching grades: " .. status)
        return
    end

    local grades = json.decode(response)
    return grades
end

-- Function to render the grades in HTML format
function render_grades(grades)
    if not grades or #grades == 0 then
        print("No grades available.")
        return
    end

    local grade_list_html = ""
    for _, grade in ipairs(grades) do
        grade_list_html = grade_list_html .. string.format("<li class=\"grade-item\"><strong>%s</strong>: %s (Grade: %s)</li>", grade.subject, grade.teacher, grade.grade)
    end

    -- Replace the placeholder with the actual grade list
    local updated_html = string.gsub(html, '<ul id="grades-list"></ul>', '<ul id="grades-list">' .. grade_list_html .. '</ul>')

    -- Save the updated HTML with grade list
    local file = io.open("../grades.html", "w")
    file:write(updated_html)
    file:close()

    print("HTML file created with grades. Open grades.html to test.")
end

-- Main function to fetch and render grades
function main()
    local grades = fetch_grades()
    render_grades(grades)
end

main()