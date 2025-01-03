Shared = {}
QBCore = exports['qb-core']:GetCoreObject()
Shared.DutySystem = true 
Shared.DefaultGroup = { name = "user", label = "Igrac servera" }

Shared.StaffGroups = { -- # every group from this table can go on/off duty
   {name = 'vlasnik', label = "Vlasnik servera", enableHidden = true }, -- # , enableHidden = boolean ( hidden duty )
   {name = 'developer', label = "Developer servera", enableHidden = true},
   {name = 'headstaff', label = "Head-Staff", enableHidden = false},
   {name = 'superadmin', label = "Super-Admin", enableHidden = false},
   {name = 'admin', label = "Administrator", enableHidden = false},
   {name = 'probniadmin', label = "Probni-Administrator", enableHidden = false},
   {name = 'vulegg', label = "Tata-Igrice", enableHidden = true},
}

Shared.CommandNames = {
   setgroup = "setgroup", 
   aduty = "aduty",
}

--[[ THIS IS EXAMPLE HOW YOU CAN SET SETGROUP PERMISSION 
   #===================================================================================--
   #                                    GROUPS                                         --
   #===================================================================================--
   add_principal group.admin group.user
   add_principal group.vlasnik group.user
   add_principal group.vulegg group.user
   add_principal group.developer group.user
   add_principal group.headstaff group.user
   add_principal group.probniadmin group.user
   add_principal group.superadmin group.user
   #===================================================================================--
   #                                     COMMANDS                                      --
   #===================================================================================--
   add_ace group.vlasnik command allow
   add_ace group.vlasnik command.quit deny

   add_ace group.vulegg command allow
   add_ace group.vulegg command.quit deny

   add_ace group.developer command allow
   add_ace group.developer command.quit deny

   add_ace group.headstaff command allow
   add_ace group.headstaff command.quit deny

   add_ace group.probniadmin command allow
   add_ace group.probniadmin command.quit deny

   add_ace group.superadmin command allow
   add_ace group.superadmin command.quit deny

   add_ace group.admin command allow
   add_ace group.admin command.quit deny
   #===================================================================================--
   #                                   PERMISSIONS                                     --
   #===================================================================================--

   # -- SETGROUP -- #
   add_ace group.vlasnik setgroup allow
   add_ace group.vulegg setgroup allow
   add_ace group.developer setgroup allow
   add_ace group.headstaff setgroup allow
   add_ace group.probniadmin setgroup deny
   add_ace group.superadmin setgroup deny
   add_ace group.admin setgroup deny
]]