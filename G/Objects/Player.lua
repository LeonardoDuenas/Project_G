local love = require 'love'

function Player(debugging)
    return {
        debugging = debugging or false,

        x = love.graphics.getWidth()/2,
        y = love.graphics.getHeight() - 100,
        radius = 20,
        speed = 1,
        direction = {
            up = false,
            down = false,
            left = false,
            right = false
        },
        shield = false,
        shield_radius = 0,
        shield_timer = 0,
        shield_increment_radius = 15,
        shield_bounce_factor = 25,

        changeDirection = function (self, direction)
            self.direction.up = direction == "up"
            self.direction.down = direction == "down"
            self.direction.right = direction == "right"
            self.direction.left = direction == "left"
        end,

        changeOppositeDirection = function (self, direction)
            self.direction.up = direction == "down"
            self.direction.down = direction == "up"
            self.direction.right = direction == "left"
            self.direction.left = direction == "right"
        end,

        move = function (self, width, height)

            if self.x > 0 and self.x < width and self.y > 0 and self.y < height then

                if love.keyboard.isDown("a") or self.direction.left == true then
                    self.x = self.x - self.speed
                    self:changeDirection("left")
                    
                    -- self.direction.left = true
                    -- self.direction.up = false
                    -- self.direction.down = false
                    -- self.direction.right = false
                end
                if love.keyboard.isDown("d") or self.direction.right == true then
                    self.x = self.x + self.speed
                    self:changeDirection("right")

                    -- self.direction.right = true
                    -- self.direction.up = false
                    -- self.direction.down = false
                    -- self.direction.left = false
                end
                if love.keyboard.isDown("w") or self.direction.up == true then
                    self.y = self.y - self.speed
                    self:changeDirection("up")

                    -- self.direction.up = true
                    -- self.direction.left = false
                    -- self.direction.down = false
                    -- self.direction.right = false
                end
                if love.keyboard.isDown("s") or self.direction.down == true then
                    self.y = self.y + self.speed
                    self:changeDirection("down")

                    -- self.direction.down = true
                    -- self.direction.up = false
                    -- self.direction.left = false
                    -- self.direction.right = false
                end
            end
        end,

        deactivate_shield = function (self, dt)
            if self.shield then
                self.shield_timer = self.shield_timer + dt

                if self.shield_timer >= 0.33 then
                    self.shield = false
                    self.shield_radius = 0
                    self.shield_timer = 0
                end
            end

        end,

        activate_shield = function (self)
            self.shield = true
            self.shield_radius = self.radius + self.shield_increment_radius
            self.shield_timer = 0
        end,

        draw = function (self, opacity)
            love.graphics.setColor(255, 255, 255, opacity)
            love.graphics.circle('fill', self.x, self.y, self.radius)
            love.graphics.setColor(255, 255, 255)

            if self.shield then
                love.graphics.setColor(0, 0, 255, opacity)
                love.graphics.circle('line', self.x, self.y, self.radius + self.shield_increment_radius)
                love.graphics.setColor(255, 255, 255)
            end

            if debugging then
                love.graphics.setColor(255, 0, 0, opacity)
                love.graphics.circle('line', self.x, self.y, self.radius)
                love.graphics.setColor(255, 255, 255)
            end
        end,

        Collided = function (self, asteroids)
            if not (self.x > 0 and self.x < love.graphics.getWidth() and self.y > 0 and self.y < love.graphics.getHeight()) then
                return true
            end

            for _, asteroid in pairs(asteroids) do

                if math.sqrt((self.x - asteroid.x)^2 + (self.y - asteroid.y)^2) < self.radius + asteroid.radius then
                --If the distance between the player and the asteroid is less than the sum of their radius, then the player collided
                    return true
                end
            end
            return false
        end,

        --SHIELD CONDITION: The disance between player and ast is EQUAL to the sum of their radius, then both radius are touching
        ShieldCollision = function (self, asteroids, dt)

            for _, asteroid in pairs(asteroids) do

                local distance = math.sqrt((self.x - asteroid.x)^2 + (self.y - asteroid.y)^2)

                if distance < self.shield_radius + asteroid.radius then
                    --bounce to the opposite direction
                    if self.direction.up then
                        self:changeOppositeDirection("up")
                        self.y = self.y + self.shield_bounce_factor + dt
                    elseif self.direction.down then
                        self.y = self.y - self.shield_bounce_factor + dt
                        self:changeOppositeDirection("down")
                    elseif self.direction.left then
                        self:changeOppositeDirection("left")
                        self.x = self.x + self.shield_bounce_factor + dt
                    elseif self.direction.right then
                        self.x = self.x - self.shield_bounce_factor + dt
                        self:changeOppositeDirection("right")
                    end

                    --increment speed
                    local max_speed = 2
                    if self.speed < max_speed then
                        self.speed = self.speed + 0.05
                    end

                    --remove the asteroid
                    asteroid.health = asteroid.health - 1
                    asteroid.first_collision = true

                    if asteroid.health == 0  then
                        table.remove(asteroids, _)
                    end
                end
            end
        end,
    }
end

return Player