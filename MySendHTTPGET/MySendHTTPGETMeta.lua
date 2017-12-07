 local oo            = require("loop.simple")
 local AppletMeta    = require("jive.AppletMeta")
 local appletManager = appletManager
 local jiveMain      = jiveMain
 
 module(...)
 oo.class(_M, AppletMeta)
  
 function jiveVersion(meta)
       return 1, 1
 end
 
 function defaultSettings(meta)
       return {
               currentSetting = 0,
			   ihcIP = "200.0.0.0",
			   showRooms = 1,
			   zwDevices = {rooms = {}, types = {}, protected = {}, names = {},},
			   showProtected = 1,
			   showAllOff = 1,
			   zwSceneNames = {"[Empty]", "[Empty]", "[Empty]", "[Empty]", "[Empty]", "[Empty]", "[Empty]", "[Empty]", "[Empty]"},
			   zwScenes = {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}},
			   wol = {"000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000","000000000000",},
       }
 end
 
 function registerApplet(meta)
	jiveMain:addItem(meta:menuItem('MySendHTTPGETApplet', 'home', "MySendHTTPGET", function(applet, ...) applet:menu(...) end, 20))
	jiveMain:addItem(meta:menuItem('SettingsApplet', 'settings', "SETTINGS_MENU", function(applet, ...) applet:settingsmenu(...) end, 40))
 end
