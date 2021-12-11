-- Copyright (C) 2021 Tim Sarbin
-- This file is part of OpenDiablo2 <https://github.com/AbyssEngine/OpenDiablo2>.
--
-- OpenDiablo2 is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- OpenDiablo2 is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with OpenDiablo2.  If not, see <http://www.gnu.org/licenses/>.
--
require("string")

function Split(s, delimiter)
    local result = {};
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match);
    end
    return result;
end

--- Loads a tab seperated file into a table
--- @param filePath string # The path to the file
--- @param firstFieldIsHandle boolean # Whether the first field is the handle
--- @return table # The table containing the file contents
function LoadTsvAsTable(filePath, firstFieldIsHandle)
    local tsvData = abyss.createString(filePath)

    local lines = {}

    for s in tsvData:gmatch("[^\r\n]+") do
        table.insert(lines, s .. "\t")
    end

    local fields = {}

    local fieldstart = 1
    repeat
        local nexti = lines[1]:find("\t", fieldstart)
        table.insert(fields, lines[1]:sub(fieldstart, nexti - 1))
        fieldstart = nexti + 1
    until fieldstart > lines[1]:len()

    local result = {}

    for i = 2, #lines do
        local line = lines[i]
        local fieldIdx = 0
        local item = {}

        fieldstart = 1
        repeat
            fieldIdx = fieldIdx + 1
            local nexti = line:find("\t", fieldstart)
            item[fields[fieldIdx]:gsub("%s+", "_")] = line:sub(fieldstart, nexti - 1)
            fieldstart = nexti + 1
        until fieldstart > line:len()

        if firstFieldIsHandle then
            result[item[fields[1]:gsub("%s+", "_")]] = item
        else
            table.insert(result, item)
        end
    end

    return result
end
