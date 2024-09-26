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

local stat = {}

-- Constants
SMALLER = 0
STRICT_SMALLER = 1
EQUAL = 2
STRICT_BIGGER = 3
BIGGER = 4 

-- Widget name
local translations = {en="Status", fr="État"}
local function name(widget)
    local locale = system.getLocale()
    return translations[locale] or translations["en"]
end

-- First initialisation
function stat.create()
    return {source=nil, thresholdType=0, thresholdValue=0, value=0, colorOn=GREEN,colorOff=RED}
end

-- Retrieve cell count of the battery plugged
local function getCellCount(widget)
	local voltStep = widget.maxVolt/10 + 0.1  -- +0.1V tolerance
	return math.floor(widget.value / voltStep) + 1
end

-- Get percentage of battery left
local function getPercentage(widget, i)
	local batt = widget.value / i
	if batt <= widget.minVolt/10 then
		return 0
	elseif batt >= widget.maxVolt/10 then
		return 100
	else
		return math.floor((batt-widget.minVolt/10)/(widget.maxVolt-widget.minVolt)*1000)
	end
end

-- Drawing of the widget
function stat.paint(widget)
	--local t
	--t=os.clock()
    -- Get widget size
	local w, h = lcd.getWindowSize()

    if widget.source == nil then
        return
    end
	
	-- Write channel name in title
	lcd.font(FONT_S)
    local s = widget.source:name()
    local text_w, text_h = lcd.getTextSize(s)
    lcd.drawText(w/2-text_w/2, 2, s, LEFT)
	
	-- Draw perimeter
	lcd.color(BLACK)
	lcd.drawRectangle(2, text_h+2, w-4, h-text_h-4)
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
	lcd.drawFilledRectangle(3, text_h+3, w-6, h-text_h-6)
	--print("StatRun_"..os.clock()-t)
end

-- Trigger to redraw the widget
function stat.wakeup(widget)
	--local t
	--t = os.clock()
    if not lcd.isVisible() then
    	return
    end
	if widget.source then
		local newValue = widget.source:value()
		if widget.value ~= newValue then
			widget.value = newValue
			lcd.invalidate()
		end
	end
	
	--print("StatWake_"..os.clock()-t)
end

-- Widget options
function stat.configure(widget)
    -- Source
    line = form.addLine("Source")
    form.addSourceField(line, nil, function() return widget.source end, function(value) widget.source = value end)

    -- Color Off / On
    line = form.addLine("Color OFF / ON")
    local slots = form.getFieldSlots(line, {0, "-", 0})
    form.addColorField(line, slots[1], function() return widget.colorOff end, function(value) widget.colorOff = value end)
	form.addStaticText(line, slots[2], "/")
    form.addColorField(line, slots[3], function() return widget.colorOn end, function(value) widget.colorOn = value end)

    -- Threshold type + value
    line = form.addLine("Threshold")
	local thresholdTypes = { {">=", BIGGER}, {">", STRICT_BIGGER}, {"=", EQUAL} , {"<", STRICT_SMALLER}, {"<=", SMALLER}}
    local slots = form.getFieldSlots(line, {100,0})
    form.addChoiceField(line, slots[1], thresholdTypes, function() return widget.thresholdType end, function(value) widget.thresholdType = value end)
    form.addNumberField(line, slots[2], -1024, 1024, function() return widget.thresholdValue end, function(value) widget.thresholdValue = value end)
end

-- Read settings from storage
function stat.read(widget)
    widget.source = storage.read("source")
    widget.colorOff = storage.read("colorOff")
    widget.colorOn = storage.read("colorOn")
	widget.thresholdType = storage.read("thresholdType")
	widget.thresholdValue = storage.read("thresholdValue")
end

-- Write settings to storage
function stat.write(widget)
    storage.write("source", widget.source)
    storage.write("colorOff", widget.colorOff)
    storage.write("colorOn", widget.colorOn)
    storage.write("thresholdType", widget.thresholdType)
    storage.write("thresholdValue", widget.thresholdValue)
end

return stat