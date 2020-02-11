USE [AccountLog]
GO
/****** Object:  StoredProcedure [dbo].[p_IPBlock_IsBlock]    Script Date: 12/10/2018 11:27:13 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[p_IPBlock_IsBlock]
/*
 Fixed by Gherblino
 
 Is IP block ?
 input:
  IP
 output: 
  bIsBlock, 0=No block, 1=Block
*/
	@nUserNo    int
,	@sIP 		nvarchar(20)
,	@bIsBlock	tinyint OUTPUT
AS
BEGIN
	SET NOCOUNT ON

	SET @bIsBlock = 0
	
	SET @sIP = (cast(cast(parsename(@sIP, 4) as int) as varchar(255)) + '.' +
        cast(cast(parsename(@sIP, 3) as int) as varchar(255)) + '.' +
        cast(cast(parsename(@sIP, 2) as int) as varchar(255)) + '.' +
        cast(cast(parsename(@sIP, 1) as int) as varchar(255)))

	IF EXISTS(SELECT sIPStart FROM tIPBlock WHERE @sIP >= sIPStart AND @sIP <= sIPEnd) BEGIN
		IF NOT EXISTS(SELECT TOP 1 nLogNo FROM tAccountLog WHERE nUserNo = @nUserNo AND nType = 1) BEGIN
			SET @bIsBlock = 1
		END
		SET @bIsBlock = 1
	END

	SET NOCOUNT OFF
END
-- end

