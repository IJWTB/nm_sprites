
// Wire Sprites by NickMBR and PTugaSantos
// See also: gmod_wire_nm_sprite.lua

WireToolSetup.setCategory( "Visuals" )
WireToolSetup.open( "nm_sprites", "Sprite", "gmod_wire_nm_sprite", nil, "Sprites" )

if CLIENT then
	// Tool Strings and ConVars
	language.Add( "tool.wire_nm_sprites.name", "Wire Sprites" )
	language.Add( "tool.wire_nm_sprites.desc", "Creates a customizable sprite entity." )
	language.Add( "tool.wire_nm_sprites.0", "Primary: Create Sprite Entity" )
	
	language.Add( "NMSprite_Scale", "Scale:" )
	language.Add( "NMSprite_RenderMode", "Render Mode:" )
	language.Add( "NMSprite_SpriteColor", "Color:" )
	language.Add( "NMSprite_FrameRate", "Framerate:" )
	language.Add( "NMSprite_SpriteText", "Texture:" )
	
	TOOL.ClientConVar = {
		model = "models/beer/wiremod/watersensor_mini.mdl",
		spr_scale = 1,
		spr_rendermode = 9,
		spr_framerate = 10,
		spr_texture = "sprites/light_glow03.vmt",
		r = 0,
		g = 0,
		b = 0,
		a = 0
	}
	
	// List of sprites textures
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
	for key, texture in pairs( textures ) do  list.Set( "SpriteTextures", texture, true ) end
	
	// List of placeholders props
	list.Set( "NMSpriteModels", "models/beer/wiremod/watersensor_mini.mdl", true )
	list.Set( "NMSpriteModels", "models/beer/wiremod/hydraulic_mini.mdl", true )
	
	// CPanel Constructor
	function TOOL.BuildCPanel( panel )
		
		// Header
		WireToolHelpers.MakePresetControl( panel, "wire_nm_sprites" )
		panel:AddControl( "Header", { Text = "#tool.wire_nm_sprites.name" }  )
		
		// List base models for sprite base
		local models = list.Get( "NMSpriteModels" )
		WireDermaExts.ModelSelect( panel, "wire_nm_sprites_model", models, 1 )
		
		// List sprites from custom list
		local params = {
			Label = "#Texture",
			Height = "150",
			MenuButton = "0",
			Options = {}
		}
		for key, _ in pairs( list.Get( "SpriteTextures" ) ) do params.Options[key] = { wire_nm_sprites_spr_texture = key } end
		panel:AddControl( "ListBox", params )
		
		// Set Framerate and Scale of the sprite
		panel:NumSlider( "#NMSprite_FrameRate", "wire_nm_sprites_spr_framerate", 0, 30, 0 )
		panel:NumSlider( "#NMSprite_Scale", "wire_nm_sprites_spr_scale", 0, 100, 2 )
		
		// Sets the render mode of the sprite
		panel:AddControl( "ComboBox", {
				Label = "#NMSprite_RenderMode",
				Options = {
					["World Glow"] = { wire_nm_sprites_spr_rendermode = 9 },
					Glow = { wire_nm_sprites_spr_rendermode = 3 }
				}
			}
		)
		
		// Adds a color mixer with alpha enabled.
		panel:AddControl( "Color", {
				Label		= "#NMSprite_SpriteColor",
				Red			= "wire_nm_sprites_r",
				Green		= "wire_nm_sprites_g",
				Blue		= "wire_nm_sprites_b",
				Alpha		= "wire_nm_sprites_a",
				ShowAlpha	= "1",
				ShowHSV		= "1",
				ShowRGB		= "1",
				Multiplier	= "255"
			}
		)
	end
end

WireToolSetup.BaseLang()
WireToolSetup.SetupMax( 25 )

if SERVER then
	function TOOL:GetConVars()
		
		local rtn = {
			self:GetClientNumber("spr_scale"),
			self:GetClientNumber("spr_framerate"),
			self:GetClientNumber("spr_rendermode"),
			self:GetClientInfo("spr_texture"),
			self:GetClientNumber("r"),
			self:GetClientNumber("g"),
			self:GetClientNumber("b"),
			self:GetClientNumber("a")
		}
		
		return unpack( rtn )
	end
end