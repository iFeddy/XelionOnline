USE [w00_Character]
GO
/****** Object:  StoredProcedure [dbo].[usp_Tutorial_setCharInfo]    Script Date: 12/26/2018 9:07:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*--------------------------------------------------------------------------------------
' 이  름 : usp_Tutorial_setCharInfo
' 작성자 : Ko Dong Gyun(kodong@gmail.com)
' 작성일 : 2013.5.20.
' Description :
'   캐릭터의 튜토리얼 진행 정보를 기록함.
' Parameter :
'	input Parameter
'		@nUserNo : 유저번호
'	output Parameter
'		@nRet	 : check SQL execute(valid/invalid)
'			= 0	 : works ok
'			< 0	 : error
'-------------------------------------------------------------------------------------*/
ALTER PROCEDURE [dbo].[usp_Tutorial_setCharInfo]
	@nUserNo int
,	@nCharNo int
,	@nState  tinyint
,	@nStep   tinyint
,	@nRet    int = 0 output
AS
BEGIN
	SET NOCOUNT ON
	
	SET @nRet = 0
	
	IF EXISTS(SELECT nCharNo FROM tTutorial WHERE nUserNo = @nUserNo AND nCharNo = @nCharNo) BEGIN
		UPDATE tTutorial SET nState = @nState, nStep  = @nStep 
		 WHERE nUserNo = @nUserNo AND nCharNo = @nCharNo 
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1 BEGIN
			SET @nRet = -1
			RETURN
		END
	END
	ELSE BEGIN
		INSERT INTO tTutorial (nUserNo, nCharNo, nState, nStep)
		VALUES (@nUserNo, @nCharNo, 2, 0)
		IF @@ERROR <> 0 BEGIN
			SET @nRet = -1
			RETURN
		END		
	END
END

