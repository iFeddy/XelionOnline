require( "common" )

gIsInit 	= false		-- �ʱ�ȭ �Ǿ���? ����
------------------------------------------------------------------------------------------------------
--
-- FUNCTION : CPP -> LUA
--
------------------------------------------------------------------------------------------------------
function DummyFunction()
end


function EldCastleLordElderiss( Handle, MapIndex )
cExecCheck( "EldCastleLordElderiss" )


	-- �̺�Ʈ �ʱ�ȭ
	if gIsInit == false
	then

		-- AISctipt Function ����
		cAIScriptFunc( Handle, "NPCClick", "EldCastleLordElderiss_Click" )
		cAIScriptFunc( Handle, "NPCMenu",  "EldCastleLordElderiss_Menu"  )

		gIsInit = true;

	end

end


function EldCastleLordElderiss_Click( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "EldCastleLordElderiss_Click" )

	-- ���̾�α� �޴� ���
	cNPCMenuOpen( NPCHandle, PlyHandle )

end


function EldCastleLordElderiss_Menu( NPCHandle, PlyHandle, PlyCharNo, Value )
cExecCheck( "EldCastleLordElderiss_Menu" )

	-- Ŭ���� ����? ����
	if Value == 1
	then

		cClassChangeOpen( PlyHandle )

	end

end
