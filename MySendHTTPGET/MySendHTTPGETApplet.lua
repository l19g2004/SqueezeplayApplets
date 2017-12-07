--[[
=head1 NAME

applets.MySendHTTPGET.MySendHTTPGETApplet - MySendHTTPGET Applet

=head1 DESCRIPTION

Test with a send GET message via http

=head1 FUNCTIONS



=cut
--]]



local tostring 			= tostring
local tonumber 			= tonumber
local assert 				= assert
local oo					= require("loop.simple")
local string				= require("string")
local pairs 				= pairs
local ipairs 				= ipairs
local table 				= table
local jnt					= jnt
local Applet				= require("jive.Applet")
local RadioButton			= require("jive.ui.RadioButton")
local RadioGroup			= require("jive.ui.RadioGroup")
local Window				= require("jive.ui.Window")
local Popup				= require("jive.ui.Popup")
local Textarea				= require('jive.ui.Textarea')
local Icon					= require("jive.ui.Icon")
local SimpleMenu			= require("jive.ui.SimpleMenu")
local Timer				= require("jive.ui.Timer")
local RadioGroup			= require("jive.ui.RadioGroup")
local Checkbox				= require("jive.ui.Checkbox")
local Slider				= require("jive.ui.Slider")
local Choice				= require("jive.ui.Choice")
local Socket				= require("jive.net.SocketTcp")
-- local UdpBroadcast			= require("jive.net.SocketUdpBcast")
local log					= require("jive.utils.log").addCategory("MySendHTTPGET", jive.utils.log.DEBUG)
local tcpsock				= require("socket.core")

local Textinput			= require("jive.ui.Textinput")
local Label				= require("jive.ui.Label")
local lxp					= require("lxp")

local SocketHttp	= require("jive.net.SocketHttp")
local RequestHttp	= require("jive.net.RequestHttp")


local EVENT_KEY_PRESS		= jive.ui.EVENT_KEY_PRESS
local KEY_GO				= jive.ui.KEY_GO
local KEY_PLAY				= jive.ui.KEY_PLAY
local KEY_ADD				= jive.ui.KEY_ADD
local EVENT_HIDE			= jive.ui.EVENT_HIDE
local EVENT_SHOW			= jive.ui.EVENT_SHOW


module(...)
oo.class(_M, Applet)

-- show menu in the settings direction

function settingsmenu(self)
log:info("settings menu")
local showRooms = self:getSettings().showRooms
local showProtected = self:getSettings().showProtected
local showAllOff = self:getSettings().showAllOff
--local v = Textinput.ipAddressValue("0.0.0.0")
local currentSetting = self:getSettings().currentSetting
local group = RadioGroup()
local reset = 2
local window = Window("windowset", self:string("SETTINGS_MENU"))
if self:getSettings().resetOnStartup then reset = 1 end
local menu = SimpleMenu("menu", {

{
text = self:string("DISPLAY_ROOMS"),
icon = Choice(
"choice",
{self:string("YES"),self:string("NO")},
function(self1, selectedIndex)
log:info("New Showrooms setting " .. selectedIndex)
--settings={}
self:getSettings()['showRooms'] = selectedIndex
self:storeSettings()

end,
showRooms)
},
{
text = self:string("SHOW_PROTECTED_DEVICES"),
icon = Choice(
"choice",
{self:string("YES"), self:string("NO")},
function(self1, selectedIndex)
log:info("New Show protected setting " .. selectedIndex)
--settings={}
self:getSettings()['showProtected'] = selectedIndex
self:storeSettings()

end,
showProtected)
},
{
text = self:string("SHOW_ALL_OFF"),
icon = Choice(
"choice",
{self:string("YES"), self:string("NO")},
function(self1, selectedIndex)
log:info("New Show ALL OFF setting " .. selectedIndex)
--settings={}
self:getSettings()['showAllOff'] = selectedIndex
self:storeSettings()

end,
showAllOff)

},
{
text = self:string("SCENES_SETTINGS"),
callback = function(event, menuItem)
scenesSettingsMenu(self)
end
},
{
text = self:string("TIMER_SETTINGS"),
callback = function(event, menuItem)
timerSettings(self)
end
},
{
text = self:string("SYNC_WITH_IHC"),
callback = function(event, menuItem)
syncWithIHC(self, self:getSettings().ihcIP)
end
},
{
text = self:string("IHCIP"),
sound = "WINDOWSHOW",
callback = function(event, menuItem)
log:info("Call get ip menu")
self:ipinputWindow()
log:info("Back from input")
--window:playSound("WINDOWSHOW")
--window:hide(Window.transitionPushLeft)

end
},
{
text = self:string("RESET_SETTINGS"),
icon = Choice("choice",
{self:string("YES"), self:string("NO")},
function (self1, selectedIndex)
log:info("Selected index= ", selectedIndex)
if ( selectedIndex == 1) then
log:info("Setting reset flag and starting timer")
window:addWidget(Textarea("softHelp", self:string("CONFIRM_RESET_SETTINGS")))
window:addWidget(Label("softButton1", self:string("YES")))
window:addWidget(Label("softButton2", self:string("NO")))
window:addListener(EVENT_KEY_PRESS,	function(evt, menuItem)
if (evt:getKeycode() == KEY_ADD) then
log:info("Reset confirmed")
self:getSettings().ihcIP = "0.0.0.0"
self:getSettings().showRooms = 1
self:getSettings().zwDevices = {}
self:getSettings().showProtected = 1
self:getSettings().showAllOff = 1
self:getSettings().zwSceneNames = {"[Empty]", "[Empty]", "[Empty]", "[Empty]", "[Empty]", "[Empty]", "[Empty]", "[Empty]", "[Empty]"}
self:getSettings().zwScenes = {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}}
self:getSettings().wol = {"000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000"}
self:storeSettings()
window:hide(Window.transitionPushLefts)
elseif (evt:getKeycode() == KEY_PLAY) then
log:info("Reset cancled")
window:hide(Window.transitionPushLefts)
end
end)
end
end,
2)
},


})

window:addWidget(menu)
window:show()

end




-- create a sink to receive XML
local function sink(chunk, err)
    if err then
        log:debug("+++ error!: " .. err)
    elseif chunk then
        log:debug("+++ received: " .. chunk)
    end
end


-- Main program section
function menu(self, menuItem)

log:info("menu")
-- get settings from meta file
--local ihcIP = self:getSettings().ihcIP


local window = Window("window", self:string("MYSENDHTTPGET"))


local text = "blaa"


-- create a sink to receive XML


-- create a HTTP socket (see L<jive.net.SocketHttp>)
local http = SocketHttp(jnt, "www.google.de", 80, "slimserver")

text = "blaa2"

-- create a request to GET http://www.google.de
local req = RequestHttp(sink, 'GET', 'http://www.google.de:80')

-- go get it!
http:fetch(req)




local textarea = Textarea("text", text)

window:addWidget(textarea)


window:show()


end


