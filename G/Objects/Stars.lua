--Meant to be only for background
local love = require 'love'

function Stars() 
    local randomize_x = math.random(0, love.graphics.getWidth())
    local randomize_y = math.random(0, love.graphics.getHeight())

    return {
        x = randomize_x,
        y = randomize_y,
        radius = 1,
        speed = 0.1,

        move = function (self)
            if self.y > 0 then
                self.y = self.y - self.speed
            else
                self.x = math.random(0, love.graphics.getWidth())
                self.y = math.random(love.graphics.getHeight(), love.graphics.getHeight() + 10)
            end
        end,

        draw = function (self, Faded)
            love.graphics.setColor(1, 1, 1, Faded)
            love.graphics.circle("fill", self.x, self.y, self.radius)
        end,       
    }
end

return Stars