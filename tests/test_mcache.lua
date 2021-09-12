#!/usr/bin/env lua

package.path = os.getenv("HOME") .. '/?.lua;'
    .. package.path

-- require "luarocks.loader"

local socket = require("socket")
local util = require("minilib.util")
local fmt = require("frmad.config.formats")
local cachec = require("frmad.lib.cachec")
local sym = require("frmad.lib.sym").ascii

function test_mcache()
    local otab = cachec:getAll()
    local mtab = {}
    for k, v in pairs(otab) do
        mtab[k] = fmt:formatvalue(k ,v)
    end
    util:printOTable(otab)
    print("----------------")
    util:printOTable(otab)
end

test_mcache()
