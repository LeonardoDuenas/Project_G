local love = require 'love'
local Game = require 'Game'
--local Asteroid = require 'Asteroid'

local width, height = love.graphics.getDimensions()

local show_debugging = false

local Faded = 255 --1

math.randomseed(os.time())

function love.load()

    love.mouse.setVisible(false)

    _G.game = Game()


    game:startGame(show_debugging)
    --startGame() returns asteroids table

    --game:startTestGame(show_debugging)


end

function love.update(dt)
    if game.state.running then

        player:move(width, height)

        if player.x ~= width/2 or player.y ~= height - 100 then

            player:deactivate_shield(dt)

            if player.shield then
                player:ShieldCollision(asteroids, dt)
            end

            if player:Collided(asteroids) then
                game:changeGameState("ended")
            elseif #asteroids == 0 then
                game:changeGameState("player_win")
            end

            for i, asteroid in pairs(asteroids) do

                if asteroid.y < height + 600 then
                    asteroid:move(dt)
                    asteroid:rotate(dt)
                else
                    table.remove(asteroids, i)
                    table.insert(asteroids, i, game:createAsteroid(show_debugging)) 
                end
            end

            for _, star in ipairs(stars) do
                star:move()
            end

        end

    end

end

function love.draw()

    --draw background
    --at least 50 points in the background
    for _, star in ipairs(stars) do
        star:draw(Faded)
    end

    if game.state.title then
        game.drawTitleScreen()
    end

    if game.state.running or game.state.paused then
        --love.graphics.print('Width: ' .. width, 10, 10)
        --love.graphics.print('Height: ' .. height, 10, 30)
        
        player:draw(Faded)

        for _, asteroid in pairs(asteroids) do
            asteroid:draw(Faded)
        end

    elseif game.state.ended then
        game.drawLoseScreen()
    elseif game.state.player_win then
        game.drawWinScreen()
    end
    if game.state.paused then
        game.drawPausedScreen()
    end
    
end

function love.keypressed(key)
    if game.state.title then
        if key == "return" then
            game:changeGameState("running")
        end

        if key == "escape" then
            love.event.quit()
        end
    end

    if game.state.running then

        if key == "space" then
            player:activate_shield()

        end

        if key == "escape" then
            game:changeGameState("paused")
            Faded = 0.4
        end
    elseif game.state.paused then
        if key == "escape" then
            game:changeGameState("running")
            Faded = 1 
        end
    elseif game.state.ended then
        if key == "escape" then
            game:changeGameState("running")
            game:startGame(show_debugging)
            --game:startTestGame(show_debugging)
        end
    elseif game.state.player_win then

        if key == "escape" then
            game:changeGameState("title")
        end

        if key == "return" then
            game:changeGameState("running")
            game:startGame(show_debugging)
            --game:startTestGame(show_debugging)
        end
    end


end
