USE [w00_Character]
GO
/****** Object:  StoredProcedure [dbo].[usp_Guild_getHistoryList]    Script Date: 11/30/2018 10:38:15 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/*--------------------------------------------------------------------------------------
' 이  름 : usp_Guild_GetTokenAll
' 작성자 : 
' 작성일 : 
' Description :
'  길드  토너먼트 보상 토큰 데이터
' Parameter :
'	input Parameter
'		
'		
'	output Parameter
'-------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[usp_GuildAcademy_getHistoryList]

@nAcademyID int,
@nAmount int,
@nRet int output

AS
BEGIN
	SET NOCOUNT ON

	SET @nRet = 0

	SELECT TOP (@nAmount) sID, nAction, dDate FROM tGuildAcademyHistory WHERE nAcademyID = @nAcademyID

	SET NOCOUNT OFF
END