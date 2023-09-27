local menu = require("states.menu")

function love.load()
    love.window.setMode(800, 600)
    love.window.setTitle("Les 8 Américains")
    currentScene = menu
    
end

function love.draw()
    currentScene.draw()
end

function love.update(dt)
    currentScene.update(dt)
end

function switchScene(state, ...)
    currentState = require('states/' .. state)
    if currentState.load then currentState.load(...) end
end