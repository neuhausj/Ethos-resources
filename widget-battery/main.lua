---------------------------------------------------------------------------
-- Widget to display the battery from telemetry                          --
--                                                                       --
-- Author:  Jonathan Neuhaus                                             --
-- Date:    2024-09-18                                                   --
-- Version: 1.0.0                                                        --
--                                                                       --
--                                                                       --
-- License GPLv2: http://www.gnu.org/licenses/gpl-2.0.html               --
--                                                                       --
-- This program is free software; you can redistribute it and/or modify  --
-- it under the terms of the GNU General Public License version 2 as     --
-- published by the Free Software Foundation.                            --
--                                                                       --
-- This program is distributed in the hope that it will be useful        --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of        --
-- MERCHANTABILITY or FITNESS FOR borderON PARTICULAR PURPOSE. See the   --
-- GNU General Public License for more details.                          --
---------------------------------------------------------------------------

-- Constants


-- Widget name
local translations = {en="Battery", fr="Batterie"}
local function name(widget)
    local locale = system.getLocale()
    return translations[locale] or translations["en"]
end

-- First initialisation
local function create()
    return {battSource=nil, showTotalVolt=0, minVolt=30, maxVolt=42}
end

-- Retrieve cell count of the battery plugged
local function getCellCount(widget)
	local voltStep = widget.maxVolt/10 + 0.1  -- +0.1V tolerance

	return math.floor(widget.battSource:value() / voltStep) + 1
end

-- Get percentage of battery left
local function getPercentage(widget, i)
	local batt = widget.battSource:value() / i
	if batt <= widget.minVolt/10 then
		return 0
	elseif batt >= widget.maxVolt/10 then
		return 100
	else
		return math.floor((batt-widget.minVolt/10)/(widget.maxVolt-widget.minVolt)*1000)
	end
end

-- Drawing of the widget
local function paint(widget)
    -- Get widget size
	local w, h = lcd.getWindowSize()

    if widget.battSource == nil or widget.minVolt>=widget.maxVolt then
		lcd.font(FONT_STD)
		s = "Widget settings error !"
		lcd.color(COLOR_RED)
		local text_w, text_h = lcd.getTextSize(s)
        lcd.drawText(w/2-text_w/2, h/2-text_h/2, s)
		return
    end
	
	-- Display voltage + %
	lcd.color(lcd.themeColor(0))
	local i
	i = getCellCount(widget)
	if widget.showTotalVolt then
        lcd.font(FONT_XXL)
		local s = widget.battSource:value() .." V"
		local text_w, text_h = lcd.getTextSize(s)
		lcd.drawText(3*w/4-text_w/2, h/2-text_h/2+1, s, LEFT)
		
		lcd.font(FONT_XL)
		s = getPercentage(widget,i)
		local text_w, text_h = lcd.getTextSize(s)
		lcd.drawText(w/4-text_w, h/2-text_h/2+1,  s .. "%", LEFT)
		
	else
		if i>0 then
			--lcd.font(FONT_S)
			--local s = i .. "S"
			--local text_w, text_h = lcd.getTextSize(s)
			--lcd.drawText(w-text_w-10, 0, i .. "S")
			lcd.font(FONT_XXL)
			local s = widget.battSource:value() / i .." V"
			local text_w, text_h = lcd.getTextSize(s)
			--lcd.drawText(w-text_w-10, h/2-text_h/2+1, s, LEFT)
            lcd.drawText(3*w/4-text_w/2, h/2-text_h/2+1, s, LEFT)
			
			lcd.font(FONT_XL)
			s = getPercentage(widget,i)
			local text_w, text_h = lcd.getTextSize(s)
			lcd.drawText(w/4-text_w, h/2-text_h/2+1,  s .. "%", LEFT)
		else
			lcd.font(FONT_STD)
			s = "Cell calculation error !"
			lcd.color(COLOR_RED)
			local text_w, text_h = lcd.getTextSize(s)
			lcd.drawText(0, 0, "Cell calculation error")
		end
	end

	-- Display % of battery
	
end

-- Trigger to redraw the widget
local function wakeup(widget)
    if widget.battSource then
        local newValue = widget.battSource:value()
        if widget.value ~= newValue then
            widget.value = newValue
            lcd.invalidate()
        end
    end
end

-- Widget options
local function configure(widget)
    -- Source
    line = form.addLine("Battery source")
    form.addSourceField(line, nil, function() return widget.battSource end, function(value) widget.battSource = value end)

    -- Show total voltage
    line = form.addLine("Show total voltage")
	form.addBooleanField(line, nil, function() return widget.showTotalVolt end, function(value) widget.showTotalVolt = value end)
	
	-- Min / Max voltage (for % calculation)
    line = form.addLine("Min/max voltage")
	local slots = form.getFieldSlots(line, {0, "-", 0})
    local minVolt = form.addNumberField(line, slots[1], 0, 100, function() return widget.minVolt end, function(value) widget.minVolt = value end)
	minVolt:decimals(1)
	minVolt:suffix(" V")
	
	form.addStaticText(line, slots[2], "/")
    local maxVolt = form.addNumberField(line, slots[3], 0, 100, function() return widget.maxVolt end, function(value) widget.maxVolt = value end)
	maxVolt:decimals(1)
	maxVolt:suffix(" V")
end

-- Read settings from storage
local function read(widget)
    widget.battSource = storage.read("battSource")
    widget.showTotalVolt = storage.read("showTotalVolt")
    widget.minVolt = storage.read("minVolt")
    widget.maxVolt = storage.read("maxVolt")
end

-- Write settings to storage
local function write(widget)
    storage.write("battSource", widget.battSource)
    storage.write("showTotalVolt", widget.showTotalVolt)
    storage.write("minVolt", widget.minVolt)
    storage.write("maxVolt", widget.maxVolt)
end

-- Register widget
local function init()
    system.registerWidget({key="battW", name=name, create=create, paint=paint, wakeup=wakeup, configure=configure, read=read, write=write})
end

return {init=init}
