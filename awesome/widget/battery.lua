     battery_widget = widget({ type = "textbox", name = "tb_battery" })

     function get_battery(widget)
        local command = "acpi -b |sed -e 's@.*\\([0-9]:\\) [^,]*,@\\1@' -e 's@remaining@@' | sed -e :a -e '$!N;s@\\n@ | @;ta'"
  	local fh = assert(io.popen(command, "r"))
  	local text = " | "..fh:read("*l").." | "
  	fh:close()
  	return text
     end

    battery_widget.text = get_battery()
    battery_widgettimer = timer({ timeout = 60 })
    battery_widgettimer:add_signal("timeout",
        function()
        battery_widget.text = get_battery()
        end
    )

    battery_widgettimer:start()
