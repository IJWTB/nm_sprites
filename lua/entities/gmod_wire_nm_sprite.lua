
-- Wire Sprites by NickMBR and PTugaSantos
-- See also: nm_sprites.lua

DEFINE_BASECLASS( "base_wire_entity" )

ENT.Author        = "NickMaps, PTugaSantos"
ENT.PrintName     = "Sprite"
ENT.RenderGroup   = RENDERGROUP_BOTH
ENT.WireDebugName = "Sprite"

-- Client portion ends here
if CLIENT then return end



AddCSLuaFile()

local cvarMaxScale     = GetConVar( "wire_nm_sprites_max_scale" )
local cvarMaxFramerate = GetConVar( "wire_nm_sprites_max_framerate")

local MIN_SCALE     = 0.01
local MIN_FRAMERATE = 0
local MIN_COLOR     = 0
local MAX_COLOR     = 255

local function getClampedScale( num )      return math.Clamp( num, MIN_SCALE,     cvarMaxScale:GetInt() )     end
local function getClampedFramerate( num )  return math.Clamp( num, MIN_FRAMERATE, cvarMaxFramerate:GetInt() ) end
local function getClampedColor( num )      return math.Clamp( num, MIN_COLOR,     MAX_COLOR )                 end

--[[--------------------------------------------------------------------------
--
-- 	ENT:Initialize()
--
--]]--
function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetNoDraw( false )
	self.Inputs = WireLib.CreateInputs( self, {"On", "RGB [VECTOR]", "Alpha", "Scale"} )
end

--[[--------------------------------------------------------------------------
--
-- 	ENT:Setup()
--
--]]--
function ENT:Setup( spr_scale, spr_framerate, spr_rendermode, spr_texture, r, g, b, a )
	self.spr_scale      = getClampedScale( spr_scale )
	self.spr_framerate  = getClampedFramerate( spr_framerate )
	self.spr_rendermode	= spr_rendermode
	self.spr_texture    = spr_texture
	self.r              = getClampedColor( r )
	self.g              = getClampedColor( g )
	self.b              = getClampedColor( b )
	self.a              = getClampedColor( a )
	
	self:PostInitialized()
	self:UpdateSprite()
end

--[[--------------------------------------------------------------------------
--
-- 	ENT:PostInitialized()
--
--]]--
function ENT:PostInitialized()
	if IsValid( self.Sprite ) then
		self.Sprite:Remove()
	end
	
	self.Sprite = self:CreateNMSprite()
end

--[[--------------------------------------------------------------------------
--
-- 	ENT:CreateNMSprite()
--
--]]--
function ENT:CreateNMSprite( pos, texture, rendermode, r, g, b, a, framerate, scale )
	local spr = ents.Create( "env_sprite" )
	
	if not IsValid( spr ) then return end
	
	r = getClampedColor( self.r )
	g = getClampedColor( self.g )
	b = getClampedColor( self.b )
	a = getClampedColor( self.a )
	
	scale     = getClampedScale( self.spr_scale )
	framerate = getClampedFramerate( self.spr_framerate )
	
	
	spr:SetPos( self:GetPos() )
	spr:SetMoveType( MOVETYPE_NONE )
	
	spr:SetSaveValue( "model",       self.spr_texture )
	spr:SetSaveValue( "rendercolor", ("%i %i %i"):format( r, g, b ) )
	spr:SetSaveValue( "rendermode",  self.spr_rendermode )
	spr:SetSaveValue( "framerate",   framerate )
	spr:SetSaveValue( "scale",       scale )
	spr:SetKeyValue(  "renderamt",   a )
		
	spr:Spawn()
	spr:Activate()
	spr:SetParent( self )
	
	return spr
end

local triggers = {
	On    = function( self, value ) self:ToggleSprite( value ) end,
	Alpha = function( self, value ) self.a = getClampedColor( value ) end,
	Scale = function( self, value ) self.spr_scale = getClampedScale( value ) end
	RGB   = function( self, value )
		self.r = getClampedColor( value[1] )
		self.g = getClampedColor( value[2] )
		self.b = getClampedColor( value[3] )
	end,
}

--[[--------------------------------------------------------------------------
--
-- 	ENT:TriggerInput()
--
--]]--
function ENT:TriggerInput( trigger, value )
	if ( not triggers[trigger] ) then return end
	
	triggers[trigger]( self, value )
	self:UpdateSprite()
end

--[[--------------------------------------------------------------------------
--
-- 	ENT:UpdateSprite()
--
--]]--
function ENT:UpdateSprite()
	if not IsValid( self.Sprite ) then return end
	
	self.Sprite:SetKeyValue( "rendercolor", ("%i %i %i"):format( self.r, self.g, self.b ) )
	self.Sprite:SetKeyValue( "rendermode",  self.spr_rendermode )
	self.Sprite:SetKeyValue( "framerate",   self.spr_framerate )
	self.Sprite:SetKeyValue( "scale",       self.spr_scale )
	self.Sprite:SetKeyValue( "renderamt",   self.a )
end

--[[--------------------------------------------------------------------------
--
-- 	ENT:ToggleSprite()
--
--]]--
function ENT:ToggleSprite( val )
	if not IsValid( self.Sprite ) then return end
	
	self.Sprite:SetNoDraw( val ~= 1 )
end

duplicator.RegisterEntityClass( "gmod_wire_nm_sprite", WireLib.MakeWireEnt, "Data", "spr_scale", "spr_framerate", "spr_rendermode", "spr_texture", "r", "g", "b", "a" )

-- Backwards compatibility
duplicator.RegisterEntityClass( "nm_sprites", function( ply, data, ... )
	
	data.Class = "gmod_wire_nm_sprite"
	
	local params = {
		getClampedScale( data.spr_scale ),
		getClampedFramerate( data.spr_framerate )
		data.spr_rendermode,
		data.spr_texture,
		getClampedColor( data.r ),
		getClampedColor( data.g ),
		getClampedColor( data.b ),
		getClampedColor( data.a )
	}
	
	return WireLib.MakeWireEnt( ply, data, unpack( params ) )
	
end, "Data" )