USE [w00_Character]
GO
/****** Object:  StoredProcedure [dbo].[usp_GuildEmblem_GetInfo]    Script Date: 11/5/2018 10:39:27 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GuildEmblem_GetInfo]

@nGuildNo INT

AS
BEGIN
	SET NOCOUNT ON
	SELECT nColor, nIcon, dCreated, dUpdated, nUnk FROM tGuildEmblem
	WHERE nGuildNo = @nGuildNo
	SET NOCOUNT OFF
END