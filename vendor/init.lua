---
--vendor 1.01
--Copyright (C) 2012 Bad_Command
--
--This library is free software; you can redistribute it and/or
--modify it under the terms of the GNU Lesser General Public
--License as published by the Free Software Foundation; either
--version 2.1 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU Lesser General Public
--License along with this library; if not, write to the Free Software
--Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
---

--[[
New change by fairiestoy:
Implement a block, which allows to send mesecon signals
after a payment. This could be useful for exclusive access
to specific rooms only for example.
]]


vendor = {}
vendor.version = 1.1
vendor.tax = 0.01
vendor.time_setting = 2 -- indicates the amount ( in seconds ) after which the mesecon signal is turned off again.


dofile(minetest.get_modpath("vendor") .. "/vendor.lua")

-- comment out this line to disable logging
dofile(minetest.get_modpath("vendor").."/log.lua")


-- Register Start Mese Vendor By fairiestoy
if minetest.get_modpath("mesecons") ~= nil then
	minetest.register_node( 'vendor:signal_vendor_off', {
		description = 'Signal Vendor',
		tile_images = {'vendor_side.png', 'vendor_side.png', 'vendor_side.png',
					'vendor_side.png', 'vendor_side.png', 'vendor_vendor_front.png'},
		paramtype = 'light',
		paramtype2 = 'facedir',
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		after_place_node = function( pos, placer )
			print( 'Placed a new signal vendor')
			local meta = minetest.env:get_meta(pos)
			meta:set_int("cost", 0)
			meta:set_int("limit", 0)
			meta:set_string("owner", placer:get_player_name() or "")
			meta:set_string("formspec", vendor.mese_formspec(pos, placer))
			local description = minetest.registered_nodes[minetest.env:get_node(pos).name].description
			vendor.disable(pos, "New " .. description)
		end,
		can_dig = vendor.can_dig,
		on_receive_fields = vendor.mese_on_receive_fields,
		on_punch = vendor.mese_on_punch,
		mesecons = {receptor = {
			state = mesecon.state.off,
			rules = mesecon.rules.buttonlike_get
		}},
		})
	
	minetest.register_node( 'vendor:signal_vendor_on', {
		description = 'Signal Vendor',
		tile_images = {'vendor_side.png', 'vendor_side.png', 'vendor_side.png',
					'vendor_side.png', 'vendor_side.png', 'vendor_vendor_front.png'},
		paramtype = 'light',
		paramtype2 = 'facedir',
		drop = 'vendor:signal_vendor_off',
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		mesecons = {receptor = {
			state = mesecon.state.on,
			rules = mesecon.rules.buttonlike_get
		}},
		})
end
-- Register End Mese Vendor By fairiestoy




minetest.register_node("vendor:vendor", {
	description = "Vending Machine",
	tile_images ={"vendor_side.png", "vendor_side.png", "vendor_side.png",
		"vendor_side.png", "vendor_side.png", "vendor_vendor_front.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},

	after_place_node = vendor.after_place_node,
	can_dig = vendor.can_dig,
	on_receive_fields = vendor.on_receive_fields,
	on_punch = vendor.on_punch,
})

minetest.register_node("vendor:depositor", {
	description = "Depositing Machine",
	tile_images ={"vendor_side.png", "vendor_side.png", "vendor_side.png",
		"vendor_side.png", "vendor_side.png", "vendor_depositor_front.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},

	after_place_node = vendor.after_place_node,
	can_dig = vendor.can_dig,
	on_receive_fields = vendor.on_receive_fields,
	on_punch = vendor.on_punch,
})

if minetest.get_modpath("mesecons") ~= nil then
	minetest.register_craft({
		output = 'vendor:signal_vendor_off',
		recipe = {
	                {'default:wood', 'default:wood', 'default:wood'},
	                {'default:wood', 'default:steel_ingot', 'default:wood'},
	                {'default:wood', 'mesecons:wire_00000000_off', 'default:wood'},
	        }
	})
end

minetest.register_craft({
	output = 'vendor:vendor',
	recipe = {
                {'default:wood', 'default:wood', 'default:wood'},
                {'default:wood', 'default:steel_ingot', 'default:wood'},
                {'default:wood', 'default:steel_ingot', 'default:wood'},
        }
})

minetest.register_craft({
	output = 'vendor:depositor',
	recipe = {
                {'default:wood', 'default:steel_ingot', 'default:wood'},
                {'default:wood', 'default:steel_ingot', 'default:wood'},
                {'default:wood', 'default:wood', 'default:wood'},
        }
})


