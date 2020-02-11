USE [w00_Character]
GO
/****** Object:  StoredProcedure [dbo].[usp_Guild_setHistory]    Script Date: 11/30/2018 10:37:03 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GuildAcademy_setHistory]
/*
Set Guild Token
2008.12 By Lunar
Input:
    See SQL
    
Output:
    nRet = -1,  Error(Not found guild)
    nRet = -2,  Error(Not found guild)
    nRet = 1,  OK
*/
@nAcademyID int,
@nCharNo int,
@sID nvarchar(50),
@nAction int,
@nRet int output

AS
BEGIN
	SET NOCOUNT ON

	SET @nRet = 0

	INSERT INTO tGuildAcademyHistory (nAcademyID, nCharNo, sID, dDate, nAction)
	VALUES (@nAcademyID, @nCharNo, @sID, CURRENT_TIMESTAMP, @nAction)

	IF @@ERROR <> 0
	BEGIN
		SET @nRet = -2
		RETURN
	END

	SET NOCOUNT OFF
END