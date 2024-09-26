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

local config = {}
config.moduleName = "Battery"
config.moduleDir = "/scripts/widget-battery/"
config.useCompiler = true

compile = assert(loadfile(config.moduleDir .. "compile.lua"))(config)
batt = assert(compile.loadScript(config.moduleDir .. "loadable.lua"))(config, compile)


local function create()
    return batt.create()
end

local function paint(widget)
    if lcd.isVisible() then
    	return batt.paint(widget)
    end
end

local function wakeup(widget)
	if lcd.isVisible() then
    	return batt.wakeup(widget)
    end
end

local function configure(widget)
    return batt.configure(widget)
end

local function read(widget)
    return batt.read(widget)
end

local function write(widget)
    return batt.write(widget)
end

local function init()
  system.registerWidget({key="battW", name=config.moduleName, create=create, paint=paint, wakeup=wakeup, configure=configure, read=read, write=write, title=false})
end

return {init=init}