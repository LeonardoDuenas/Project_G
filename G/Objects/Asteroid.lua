local love = require 'love'

function Asteroid(x, y, level, debugging)
    -- range of creation
    -- x: width/2 - 100 to width/2 + 100
    -- y: height + 10 to height + 100
    local size_randomizer = math.random(1, 10)

    --ASTEROID HEALTH: AMOUNT OF HITS NEEDED TO DESTROY IT
    --HUGE: 5, MEDIUM: 2, SMALL: 1


    if size_randomizer == 1 then
        ASTEROID_SIZE = math.random(300, 500) --huge asteroid 1/10
        ASTEROID_SPEED = 50 * level
        ASTEROID_ROTATION_ANGLE = math.random(0, 10) --math.random(0, math.pi/4)
        ASTEROID_HEALTH = 5
        
    elseif size_randomizer <= 4 then
        ASTEROID_SIZE = math.random(150, 240) --medium asteroid 1/4
        ASTEROID_SPEED = 60 * level
        ASTEROID_ROTATION_ANGLE = math.random(10, 20)--math.random(math.pi/4, math.pi)
        ASTEROID_HEALTH = 2
    else
        ASTEROID_SIZE = math.random(50, 100) --small asteroid 1/2
        ASTEROID_SPEED = 90 * level
        ASTEROID_ROTATION_ANGLE = math.random(20, 30)--math.random(math.pi, 2 * math.pi)
        ASTEROID_HEALTH = 1
    end

    --speed_offset: factor to make the asteroid appear at different times

    debugging = debugging or false

    local ASTEROID_VERT = 10 -- average verticies... how many edges it will gave
    local ASTEROID_JAG = 0.2 -- asteroid jaggedness (less round)
    --local ASTEROID_SPEED = math.random(50) + (level * 2) 


    local vert = math.floor(math.random(ASTEROID_VERT + 1) + ASTEROID_VERT / 2) -- random number of verticies (based on the average)

    local offset = {} --offset of each verticie
    for i = 1, vert + 1 do
        -- NOTE: the math.random() * ASTEROID_JAG should be like that and NOT math.random(ASTEROID_JAG)
        -- because math.random returns an INTEGER and not a FLOAT (and we want a float)
        table.insert(offset, math.random() * ASTEROID_JAG * 2 + 1 - ASTEROID_JAG)
    end
    
    --local vel = -1
    --if math.random() < 0.5 then
    --    vel = 1
    --end
    
    return {
        x = x,
        y = y,
        --movement
        --x_vel = math.random() * ASTEROID_SPEED * vel,
        --y_vel = math.random() * ASTEROID_SPEED * vel,
        --speed_offset = math.random() * ASTEROID_SPEED,
        --
        radius = math.ceil(ASTEROID_SIZE / 2), -- for debbugging

        --Size: small, medium, huge
        --small: 50 - 100, medium: 150 - 240, huge: 300 - 500

        speed = ASTEROID_SPEED,
        speed_offset = math.random(),

        rotation_angle = ASTEROID_ROTATION_ANGLE,

        angle = math.rad(math.random(math.pi)),--math.rad(math.random(math.pi)), -- angle in radians
        vert = vert, -- verticies each vertices
        offset = offset,

        health = ASTEROID_HEALTH * level,
        first_collision = false,

        --health colors = rgb(255, 217, 0) -> rgb(255, 168, 0) -> rgb(255, 111, 0) -> rgb(255, 0, 0) -> destroy

        draw = function (self, opacity)

            love.graphics.setColor(255, 255, 255, opacity) --186 / 255, 189 / 255, 182 / 255

            if self.first_collision then

                if self.health == 4 then
                    love.graphics.setColor(255, 217, 0, opacity)
                end

                if self.health == 3 then
                    love.graphics.setColor(love.math.colorFromBytes(255, 165, 0, opacity * 255)) --love.graphics.setColor(229, 83, 0, opacity) --rgb(255, 156, 0)
                end

                if self.health == 2 then
                    love.graphics.setColor(love.math.colorFromBytes(255, 69, 0, opacity * 255)) --love.graphics.setColor(255, 111, 0, opacity
                end

                if self.health == 1 then  
                    love.graphics.setColor(255, 0, 0, opacity)
                end
            end

            local points = {self.x + self.radius * self.offset[1] * math.cos(self.angle), self.y + self.radius * self.offset[1] * math.sin(self.angle)}

            for i = 1, self.vert - 1 do --vert -1 because we already added the first point
                table.insert(points, self.x + self.radius * self.offset[i + 1] * math.cos(self.angle + i * math.pi * 2 / self.vert))
                table.insert(points, self.y + self.radius * self.offset[i + 1] * math.sin(self.angle + i * math.pi * 2 / self.vert))
            end



            local centerX, centerY = CalculatePolygonCenter(points)
            love.graphics.translate(centerX, centerY)
            love.graphics.rotate(self.rotation_angle)
            love.graphics.translate(-centerX, -centerY)

            love.graphics.polygon(
                "line",
                points
            )

            if debugging then
                love.graphics.setColor(1, 0, 0, opacity)
                
                love.graphics.circle("line", self.x, self.y, self.radius) -- the hitbox of the asteroid
            end

            love.graphics.origin()

            love.graphics.setColor(255, 255, 255, opacity)
        end,
        

        move = function (self, dt)
            --go from the top of the screen to the bottom
            self.y = self.y + (self.speed * dt / self.speed_offset)

            --offset: when to start moving
            --Each asteroid will try to avoid each other
        end,

        rotate = function (self, dt)
            self.rotation_angle = self.rotation_angle + dt * math.pi / 2
            self.rotation_angle = self.rotation_angle % (2 * math.pi)
        end

    }
end

function CalculatePolygonCenter(points)
    local totalX, totalY = 0, 0
    local numVertices = #points / 2  -- Each vertex has an x and y coordinate

    for i = 1, numVertices do
        local x, y = points[2 * i - 1], points[2 * i]
        totalX = totalX + x
        totalY = totalY + y
    end

    local centerX = totalX / numVertices
    local centerY = totalY / numVertices

    return centerX, centerY
end
--Create type of asteroids: small, medium, huge.
  --The size will affect the speed of movement and speed of rotation
  --In game, the chance of creating one or another should be different
  -- 1/2 for small, 1/4 for medium, 1/10 for huge


return Asteroid