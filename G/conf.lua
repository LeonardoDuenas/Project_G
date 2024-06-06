local love = require "love"

function love.conf(t)
    t.window.title = "G"

    t.window.width = 1200
    t.window.height = 700

    t.window.minwidth = 1000
    t.window.minheight = 500

    t.window.resizable = true
end