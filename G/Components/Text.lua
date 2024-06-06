local love = require 'love'

function Text(text, x, y, font_size, wrap_width, align, opacity)

    font_size = font_size or 'p'
    wrap_width = wrap_width or love.graphics.getWidth() --at which distance should the text line break
    align = align or 'left'
    opacity = opacity or 1 --0.1 - 1

    local fonts = {
        h1 = love.graphics.newFont('Components/gomarice_no_continue.ttf' ,60),
        h3 = love.graphics.newFont('Components/gomarice_no_continue.ttf', 40),
        p = love.graphics.newFont('Components/gomarice_no_continue.ttf', 16),
    }

    return {
        text = text,
        x = x,
        y = y,
        opacity = opacity,

        colors = {
            r = 1,
            g = 1,
            b = 1,
        },

        setColor = function (self, r, g, b)
            self.colors.r = r
            self.colors.g = g
            self.colors.b = b
        end,

        draw = function (self)
            love.graphics.setColor(self.colors.r, self.colors.g, self.colors.b, self.opacity)
            love.graphics.setFont(fonts[font_size])
            love.graphics.printf(self.text, self.x, self.y, wrap_width, align)
            love.graphics.setFont(fonts['p'])
        end
    }
end

return Text