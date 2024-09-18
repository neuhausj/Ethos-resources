---------------------------------------------------------------------------
-- Widget that displays the status of a variable according to a          --
--   specified threshold                                                 --
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
SMALLER = 0
STRICT_SMALLER = 1
EQUAL = 2
STRICT_BIGGER = 3
BIGGER = 4 

-- Widget name
local translations = {en="Status widget", fr="Widget état"}
local function name(widget)
    local locale = system.getLocale()
    return translations[locale] or translations["en"]
end

-- First initialisation
local function create()
    return {source=nil, thresholdType=0, thresholdValue=0, value=0, colorOn=GREEN,colorOff=GREY}
end

-- Drawing of the widget
local function paint(widget)
    -- Get widget size
	local w, h = lcd.getWindowSize()

    if widget.source == nil then
        lcd.font(FONT_STD)
		s = "Widget settings error !"
		lcd.color(COLOR_RED)
		local text_w, text_h = lcd.getTextSize(s)
        lcd.drawText(w/2-text_w/2, h/2-text_h/2, s)
		return
    end
	
	-- Draw perimeter
	lcd.color(BLACK)
	lcd.drawRectangle(2, 2, w-4, h-4)
	
	-- Draw status rectangle
	if widget.thresholdType == SMALLER and widget.value <= widget.thresholdValue then
		lcd.color(widget.colorOn)
	elseif widget.thresholdType == STRICT_SMALLER and widget.value < widget.thresholdValue then
		lcd.color(widget.colorOn)
	elseif widget.thresholdType == EQUAL and widget.value == widget.thresholdValue then
		lcd.color(widget.colorOn)
	elseif widget.thresholdType == STRICT_BIGGER and widget.value > widget.thresholdValue then
		lcd.color(widget.colorOn)
	elseif widget.thresholdType == BIGGER and widget.value >= widget.thresholdValue then
		lcd.color(widget.colorOn)
	else
		lcd.color(widget.colorOff)
	end
	lcd.drawFilledRectangle(4, 4, w-8, h-8)
end

-- Trigger to redraw the widget
local function wakeup(widget)
    if widget.source then
        local newValue = widget.source:value()
        if widget.value ~= newValue then
            widget.value = newValue
            lcd.invalidate()
        end
    end
end

-- Widget options
local function configure(widget)
    -- Source
    line = form.addLine("Source")
    form.addSourceField(line, nil, function() return widget.source end, function(value) widget.source = value end)

    -- Color Off / On
    line = form.addLine("Color OFF / ON")
    local slots = form.getFieldSlots(line, {0, "-", 0})
    form.addColorField(line, slots[1], function() return widget.colorOff end, function(colorOff) widget.colorOff = colorOff end)
	form.addStaticText(line, slots[2], "/")
    form.addColorField(line, slots[3], function() return widget.colorOn end, function(colorOn) widget.colorOn = colorOn end)

    -- Threshold value
    line = form.addLine("Threshold")
	local thresholdTypes = { {">=", BIGGER}, {">", STRICT_BIGGER}, {"=", EQUAL} , {"<", STRICT_SMALLER}, {"<=", SMALLER}}
    local slots = form.getFieldSlots(line, {100,0})
    form.addChoiceField(line, slots[1], thresholdTypes, function() return widget.thresholdType end, function(value) widget.thresholdType = value end)
    form.addNumberField(line, slots[2], -1024, 1024, function() return widget.thresholdValue end, function(value) widget.thresholdValue = value end)
end

-- Read settings from storage
local function read(widget)
    widget.source = storage.read("source")
    widget.min = storage.read("min")
    widget.max = storage.read("max")
    widget.colorOff = storage.read("colorOff")
    widget.colorOn = storage.read("colorOn")
	widget.thresholdType = storage.read("thresholdType")
	widget.thresholdValue = storage.read("thresholdValue")
end

-- Write settings to storage
local function write(widget)
    storage.write("source", widget.source)
    storage.write("min", widget.min)
    storage.write("max", widget.max)
    storage.write("colorOff", widget.colorOff)
    storage.write("colorOn", widget.colorOn)
    storage.write("thresholdType", widget.thresholdType)
    storage.write("thresholdValue", widget.thresholdValue)
end

-- Register widget
local function init()
    system.registerWidget({key="statusW", name=name, create=create, paint=paint, wakeup=wakeup, configure=configure, read=read, write=write})
end

return {init=init}
