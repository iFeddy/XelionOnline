USE [w00_Character]
GO
/****** Object:  StoredProcedure [dbo].[usp_ChargeItem_GetList]    Script Date: 11/30/2018 5:18:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** 개체: 저장 프로시저 dbo.usp_ChargeItem_GetList    스크립트 날짜: 2007-03-13 오후 6:25:10 ******/

/*---------------------------------------------------------------------------------------
' Name : usp_ChargeItem_GetList
' Description : 유저번호에 따른 유저창고 리스트를 가져옴
' Creator : Ko Dong Gyun(kodong@empal.com)
' Creat Date : 2006-06-17
' Parameter :
'			input Parameter
'				@USER_NO	: 유저번호
'			output Parameter
'				recordSet : rowNo, goodsNo, amount, registerDate
---------------------------------------------------------------------------------------*/
ALTER PROCEDURE [dbo].[usp_ChargeItem_GetList]
	@USER_NO INT
AS

BEGIN

	SET NOCOUNT ON
	SET LOCK_TIMEOUT 5000

	EXEC Account.dbo.usp_Charge_ItemSelectList @USER_NO

	SET NOCOUNT OFF
	SET LOCK_TIMEOUT -1

END

