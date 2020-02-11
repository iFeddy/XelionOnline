USE [w00_Character]
GO
/****** Object:  StoredProcedure [dbo].[usp_ChargeItem_Draw]    Script Date: 11/30/2018 5:16:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** 개체: 저장 프로시저 dbo.usp_ChargeItem_Draw    스크립트 날짜: 2007-03-13 오후 6:25:10 ******/
 

/*---------------------------------------------------------------------------------------
' Name : usp_ChargeItem_Draw
' Description : 인출된 아이템 인출완료 체크
'   - 이 저장프로시저에서 Error 가 발생하면 캐릭터 DB 에서 생성된 아이템을 취소하여야 함
' Creator : Ko Dong Gyun(kodong@empal.com)
' Creat Date : 2006-06-17
' Parameter :
'			input Parameter
'				@ROW_NO	: 창고번호
'				@USER_NO	: 유저번호
'			output Parameter
'				@RET
'					-2 : 창고번에 있는 유저번호와 불일치 하는경우
'					-1 : 이미 인출이 완료된 아이템
'					0 : DB Error
'					1 : Success
---------------------------------------------------------------------------------------*/
ALTER PROCEDURE [dbo].[usp_ChargeItem_Draw]
	@ROW_NO INT,
	@USER_NO INT,
	@RET	INT = 0 OUTPUT
AS

BEGIN

	SET NOCOUNT ON
	SET LOCK_TIMEOUT 5000

	EXEC Account.dbo.usp_Charge_ItemDraw @ROW_NO, @USER_NO, @RET OUTPUT
	
	SET NOCOUNT OFF
	SET LOCK_TIMEOUT -1

END

