    volume_widget = widget({ type = "textbox", name = "tb_volume",
                             align = "right" })

    function update_volume(widget)
        local fd = io.popen("amixer sget Master")
        local status = fd:read("*all")
        fd:close()
        
        local volume = tonumber(string.match(status, "(%d?%d?%d)%%")) / 100
        -- volume = string.format("% 3d", volume)

        status = string.match(status, "%[(o[^%]]*)%]")

        -- starting colour
        local sr, sg, sb = 0xFF, 0xFF, 0xFF
        -- ending colour
        local er, eg, eb = 0xFF, 0x32, 0x32

        local ir = volume * (er - sr) + sr
        local ig = volume * (eg - sg) + sg
        local ib = volume * (eb - sb) + sb
        interpol_colour = string.format("%.2x%.2x%.2x", ir, ig, ib)
        if string.find(status, "on", 1, true) then
            volume = " <span color='black' background='#" .. interpol_colour .. "'> 🔉 </span>"
        else
            volume = " <span color='red' background='white' > 🔇 </span>"
        end
        widget.text = volume
     end

    update_volume(volume_widget)
    awful.hooks.timer.register(1, function () update_volume(volume_widget) end)
