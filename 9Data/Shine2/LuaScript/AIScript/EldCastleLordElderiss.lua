require( "common" )

gIsInit 	= false		-- 초기화 되었나? ㄴㄴ
------------------------------------------------------------------------------------------------------
--
-- FUNCTION : CPP -> LUA
--
------------------------------------------------------------------------------------------------------
function DummyFunction()
end


function EldCastleLordElderiss( Handle, MapIndex )
cExecCheck( "EldCastleLordElderiss" )


	-- 이벤트 초기화
	if gIsInit == false
	then

		-- AISctipt Function 설정
		cAIScriptFunc( Handle, "NPCClick", "EldCastleLordElderiss_Click" )
		cAIScriptFunc( Handle, "NPCMenu",  "EldCastleLordElderiss_Menu"  )

		gIsInit = true;

	end

end


function EldCastleLordElderiss_Click( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "EldCastleLordElderiss_Click" )

	-- 다이얼로그 메뉴 출력
	cNPCMenuOpen( NPCHandle, PlyHandle )

end


function EldCastleLordElderiss_Menu( NPCHandle, PlyHandle, PlyCharNo, Value )
cExecCheck( "EldCastleLordElderiss_Menu" )

	-- 클래스 변경? ㅇㅇ
	if Value == 1
	then

		cClassChangeOpen( PlyHandle )

	end

end
