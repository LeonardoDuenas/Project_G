local love = require 'love'
local Asteroid = require 'Objects/Asteroid'
local Player = require 'Objects/Player'
local Text = require 'Components/Text'
local Stars = require 'Objects/Stars'

local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

function Game()
    return {
        diffculty = 1,
        state = {
            title = true,
            menu = false,
            paused = false,
            running = false,
            player_win = false,
            ended = false
        },

        changeGameState = function (self, state)
            self.state.title = state == "title"
            self.state.menu = state == "menu"
            self.state.paused = state == "paused"
            self.state.running = state == "running"
            self.state.ended = state == "ended"
            self.state.player_win = state == "player_win"

            if game.state.ended then
                game.finishGame()
            end
        end,

        drawTitleScreen = function ()
            Text(
                    "G",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h1",
                    love.graphics.getWidth(),
                    "center",
                    1
                ):draw()
            
            Text(
                    "Destroy every Asteroid",
                    0,
                    love.graphics.getHeight() * 0.6,
                    "p",
                    love.graphics.getWidth(),
                    "center",
                    1
                ):draw()
            
            Text(
                    "Press Enter to Start",
                    0,
                    love.graphics.getHeight() * 0.9,
                    "h3",
                    love.graphics.getWidth(),
                    "center",
                    1
                ):draw()
        end,

        drawPausedScreen = function ()
            Text(
                    "PAUSED",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h1",
                    love.graphics.getWidth(),
                    "center",
                    1
                ):draw()
        end,

        drawLoseScreen = function ()
            Text(
                    "YOU LOSE",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h1",
                    love.graphics.getWidth(),
                    "center",
                    1
                ):draw()
        end,

        drawWinScreen = function ()
            Text(
                    "YOU WIN",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h1",
                    love.graphics.getWidth(),
                    "center",
                    1
                ):draw()
            
            Text(
                    "Press Enter to Restart",
                    0,
                    love.graphics.getHeight() * 0.5,
                    "p",
                    love.graphics.getWidth(),
                    "center",
                    1
                ):draw()

            Text(
                    "Press Escape to Quit",
                    0,
                    love.graphics.getHeight() * 0.5 + 20,
                    "p",
                    love.graphics.getWidth(),
                    "center",
                    1
                ):draw()
        end,

        createAsteroid = function(self, debugging)
            -- asteroid x and y
            local as_x = math.random(10, width) --math.floor(math.random(width/2 - 100, width/2 + 100))
            local as_y = math.random(-(height - 100), -(height - 200)) -- above the screen -600, -800
    
            return Asteroid(as_x, as_y, self.diffculty, debugging)
        end,

        startGame = function (self, debugging)
            _G.stars = {}
            _G.asteroids = {}
            _G.player = Player(debugging)

            for i = 1, 20 do

                table.insert(asteroids, i, self:createAsteroid(debugging))

                -- asteroid x and y
                --local as_x = math.random(10, width) --math.floor(math.random(width/2 - 100, width/2 + 100))
                --local as_y = math.random(-600, -800) -- above the screen
        
                --table.insert(asteroids, i, Asteroid(as_x, as_y, self.diffculty, debugging))
            end
            
            for i = 1, 100 do
                table.insert(stars, i, Stars())
            end


        end,

        -- startTestGame = function (self, debugging)
        --     _G.asteroids = {}
        --     _G.player = Player(debugging)

        --     for i = 1, 1 do
        --         table.insert(asteroids, i, Asteroid(love.graphics.getWidth()/2, love.graphics.getHeight()/2, self.diffculty, debugging))
        --     end
        -- end,

        finishGame = function ()
            _G.asteroids = {}
        end
    }
end

return Game