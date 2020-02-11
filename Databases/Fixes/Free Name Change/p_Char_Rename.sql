USE [w00_Character]
GO
/****** Object:  StoredProcedure [dbo].[p_Char_Rename]    Script Date: 12/9/2018 11:54:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** 개체: 저장 프로시저 dbo.p_Char_Rename    스크립트 날짜: 2007-03-13 오후 6:25:11 ******/
ALTER PROCEDURE [dbo].[p_Char_Rename]
/*
Char Rename
2006.9 By CJC
 input:
	see SQL
 output:
	@nRet	0 = OK, 
	        ? = Error code
*/
@nCharNo int,
@sID nvarchar(40),
-- Output var
@nRet int OUTPUT

AS
BEGIN

SET NOCOUNT ON

IF NOT EXISTS(SELECT nCharNo FROM tCharacterChangeID WHERE bFlag = 0 AND nCharNo = @nCharNo) BEGIN
	SET @nRet = @@ERROR
	RETURN
END

UPDATE tCharacter SET sID = @sID WHERE nCharNo = @nCharNo
SET @nRet = @@ERROR

END
-- end