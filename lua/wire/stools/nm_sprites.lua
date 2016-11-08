
-- Wire Sprites by NickMBR and PTugaSantos
-- See also: gmod_wire_nm_sprite.lua

WireToolSetup.setCategory( "Visuals" )
WireToolSetup.open( "nm_sprites", "Sprite", "gmod_wire_nm_sprite", nil, "Sprites" )
WireToolSetup.BaseLang()
WireToolSetup.SetupMax( 25 )

local mode       = "wire_"..TOOL.Mode
local prefix     =  "tool."..mode.."."
local prefixlang = "#tool."..mode.."."

TOOL.Information = { "left" }

local cvarFlags        = {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}
local cvarMaxScale     = CreateConVar( mode.."_max_scale",    100, cvarFlags, "Defines the maximum scale of a sprite" )
local cvarMaxFramerate = CreateConVar( mode.."_max_framerate", 30, cvarFlags, "Defines the maximum framerate of a sprite" )

if CLIENT then

	-- Tool Strings and ConVars
	language.Add( prefix.."name", "Wire Sprites" )
	language.Add( prefix.."desc", "Creates a customizable sprite entity." )
	language.Add( prefix.."left", "Create Sprite Entity" )
	
	language.Add( mode.."_scale",       "Scale:" )
	language.Add( mode.."_rendermode",  "Render Mode:" )
	language.Add( mode.."_spritecolor", "Color:" )
	language.Add( mode.."_framerate",   "Framerate:" )
	language.Add( mode.."_spritetext",  "Texture:" )
	
	TOOL.ClientConVar = {
		model          = "models/beer/wiremod/watersensor_mini.mdl",
		spr_scale      = 1,
		spr_rendermode = 9,
		spr_framerate  = 10,
		spr_texture    = "sprites/light_glow03.vmt",
		r              = 0,
		g              = 0,
		b              = 0,
		a              = 0
	}
	
	-- List of sprites textures
	local textures = {
		"sprites/light_glow03.vmt",
		"sprites/animglow01.vmt",
		"sprites/blueflare1.vmt",
		"sprites/blueglow1.vmt",
		"sprites/flare1.vmt",
		"sprites/glow01.spr",
		"sprites/glow02.vmt",
		"sprites/glow03.vmt",
		"sprites/glow04.vmt",
		"sprites/glow06.vmt",
		"sprites/glow07.vmt",
		"sprites/glow08.vmt",
		"sprites/halo01.vmt",
		"sprites/lamphalo.vmt",
		"sprites/light_ignorez.vmt",
		"sprites/light_glow01.vmt",
		"sprites/light_glow02.vmt",
		"sprites/light_glow03.vmt",
		"sprites/redglow2.vmt",
		"sprites/redglow4.vmt",
		"sprites/fire.vmt",
		"sprites/fire1.vmt",
		"sprites/fire2.vmt"
	}
	
	for key, texture in pairs( textures ) do
		list.Set( "SpriteTextures", texture, true )
	end
	
	-- List of placeholders props
	list.Set( "NMSpriteModels", "models/beer/wiremod/watersensor_mini.mdl", true )
	list.Set( "NMSpriteModels", "models/beer/wiremod/hydraulic_mini.mdl",   true )
	
	--[[--------------------------------------------------------------------------
	--
	-- 	TOOL.BuildCPanel()
	--
	--]]--
	function TOOL.BuildCPanel( panel )
		
		-- Header
		WireToolHelpers.MakePresetControl( panel, mode )
		panel:AddControl( "Header", { Text = prefixlang.."name" }  )
		
		-- List base models for sprite base
		local models = list.Get( "NMSpriteModels" )
		WireDermaExts.ModelSelect( panel, mode.."_model", models, 1 )
		
		-- List sprites from custom list
		local params = {
			Label = "#Texture",
			Height = "150",
			MenuButton = "0",
			Options = {}
		}
		
		for key, _ in pairs( list.Get( "SpriteTextures" ) ) do
			params.Options[key] = { wire_nm_sprites_spr_texture = key }
		end
		panel:AddControl( "ListBox", params )
		
		-- Set Framerate and Scale of the sprite
		panel:NumSlider( prefixlang.."_framerate", mode.."_spr_framerate", 0,    cvarMaxFramerate:GetInt(), 0 )
		panel:NumSlider( prefixlang.."_scale",     mode.."_spr_scale",     0.01, cvarMaxScale:GetInt(),     2 )
		
		-- Sets the render mode of the sprite
		panel:AddControl( "ComboBox", {
				Label = prefixlang.."_rendermode",
				Options = {
					["World Glow"] = { [mode.."_spr_rendermode"] = 9 },
					Glow =           { [mode.."_spr_rendermode"] = 3 }
				}
			}
		)
		
		-- Adds a color mixer with alpha enabled.
		panel:AddControl( "Color", {
				Label		= prefixlang.."_spritecolor",
				Red			= mode.."_r",
				Green		= mode.."_g",
				Blue		= mode.."_b",
				Alpha		= mode.."_a",
				ShowAlpha	= "1",
				ShowHSV		= "1",
				ShowRGB		= "1",
				Multiplier	= "255"
			}
		)
	end
	
elseif SERVER then

	--[[--------------------------------------------------------------------------
	--
	-- 	TOOL:GetConVars()
	--
	--]]--
	function TOOL:GetConVars()
		return unpack({
			self:GetClientNumber( "spr_scale" ),
			self:GetClientNumber( "spr_framerate" ),
			self:GetClientNumber( "spr_rendermode" ),
			self:GetClientInfo( "spr_texture" ),
			self:GetClientNumber( "r" ),
			self:GetClientNumber( "g" ),
			self:GetClientNumber( "b" ),
			self:GetClientNumber( "a" )
		})
	end
end