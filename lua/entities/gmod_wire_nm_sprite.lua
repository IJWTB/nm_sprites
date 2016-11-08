
DEFINE_BASECLASS( "base_wire_entity" )
ENT.Author       = "NickMaps, PTugaSantos"
ENT.PrintName       = "Sprite"
ENT.RenderGroup		= RENDERGROUP_BOTH
ENT.WireDebugName	= "Sprite"

if SERVER then
	
	AddCSLuaFile()
	
	function ENT:Initialize()
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetNoDraw( false )
		self.Inputs = WireLib.CreateInputs( self, {"On", "RGB [VECTOR]", "Alpha", "Scale"} )
	end
	
	function ENT:Setup( spr_scale, spr_framerate, spr_rendermode, spr_texture, r, g, b, a )
		self.spr_scale					= math.Clamp(spr_scale, 0.01, 100)
		self.spr_framerate		= math.Clamp(spr_framerate, 0, 30)
		self.spr_rendermode	= spr_rendermode
		self.spr_texture				= spr_texture
		self.r								= math.Clamp(r, 0, 255)
		self.g								= math.Clamp(g, 0, 255)
		self.b								= math.Clamp(b, 0, 255)
		self.a								= math.Clamp(a, 0, 255)
		
		self:PostInitialized()
		self:UpdateSprite()
	end
	
	function ENT:PostInitialized()
		if IsValid( self.Sprite ) then self.Sprite:Remove()  end
		self.Sprite = self:CreateNMSprite()
	end
	
	function ENT:CreateNMSprite( pos, texture, rendermode, r, g, b, a, framerate, scale )
		local spr = ents.Create( "env_sprite" )
		
			if not IsValid( spr ) then return end
			spr:SetPos( self:GetPos() )
			spr:SetMoveType( MOVETYPE_NONE )
			
			spr:SetSaveValue( "rendermode", self.spr_rendermode )
			spr:SetSaveValue( "model", self.spr_texture )
			spr:SetSaveValue( "rendercolor", string.format( "%i %i %i", self.r, self.g, self.b ) )
			spr:SetSaveValue( "framerate", self.spr_framerate )
			spr:SetSaveValue( "scale", self.spr_scale )
			spr:SetKeyValue( "renderamt", self.a )
			
		spr:Spawn()
		spr:Activate()
		spr:SetParent( self )
		
		return spr
	end
	
	function ENT:TriggerInput( trigger, value )
		if ( trigger == "On" ) then self:ToggleSprite( value )
		elseif ( trigger == "RGB" ) then self.r, self.g, self.b = value[1], value[2], value[3]
		elseif ( trigger == "Alpha" ) then self.a = value
		elseif ( trigger == "Scale" ) then self.spr_scale = value end
		
		self:UpdateSprite()
	end
	
	function ENT:UpdateSprite()
		local spr = self.Sprite
		
		if IsValid( spr ) then
			spr:SetKeyValue( "rendercolor", string.format( "%i %i %i", self.r, self.g, self.b ) )
			spr:SetKeyValue( "rendermode", self.spr_rendermode )
			spr:SetKeyValue( "framerate", self.spr_framerate )
			spr:SetKeyValue( "scale", self.spr_scale )
			spr:SetKeyValue( "renderamt", self.a )
		end
	end
	
	function ENT:ToggleSprite( val )
		
		local spr = self.Sprite
		if IsValid( spr ) then spr:SetNoDraw( val ~= 1 ) end
		
	end
	
	duplicator.RegisterEntityClass( "gmod_wire_nm_sprite", WireLib.MakeWireEnt, "Data", "spr_scale", "spr_framerate", "spr_rendermode", "spr_texture", "r", "g", "b", "a" )
	
	// Backwards compatibility
	duplicator.RegisterEntityClass( "nm_sprites", function( ply, data, ... )
		
		data.Class = "gmod_wire_nm_sprite"
		
		local params = {
			data.spr_scale,
			data.spr_framerate,
			data.spr_rendermode,
			data.spr_texture,
			data.r,
			data.g,
			data.b,
			data.a
		}
		
		return WireLib.MakeWireEnt( ply, data, unpack( params ) )
		
	end, "Data" )
	
end