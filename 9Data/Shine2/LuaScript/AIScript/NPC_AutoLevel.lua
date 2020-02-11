require("common")

bClicked = false

Var 					= {}

Var.Item				= {}
Var.Item.Lot			= 1
Var.Item.Inx			= "RareCandy"

Var.Level				= {}
Var.Level.Max			= 110

Var.ScriptMsg			= {}
Var.ScriptMsg.Fail		= "NPC_AutoLevel_FAIL"

function NPC_AutoLevel( Handle, MapIndex )
cExecCheck( "NPC_AutoLevel" )

	if bClicked == false then
	
		cAIScriptFunc( Handle, "NPCClick", "Click" )
		cAIScriptFunc( Handle, "NPCMenu",  "Menu" )
		bClicked = true
		
	end
end

function Click( NPC, Player, Count )
cExecCheck("Click")

	cNPCMenuOpen( NPC, Player )
	
end

function Menu( NPC, Player, Count, Option )
cExecCheck( "Menu" )
	if Option == 1 then
		if cPlayerExist( Player ) ~= nil then
			local Item = cGetItemLot( Player, Var.Item.Inx )
			if Item == 0 or cGetLevel( Player ) >= Var.Level.Max then
				cScriptMessage_Obj( Player, Var.ScriptMsg.Fail )
			else
				cInvenItemDestroy( Player, Var.Item.Inx, Var.Item.Lot )
				cLevelUp( Player )
			end		
		end
	end	
end
