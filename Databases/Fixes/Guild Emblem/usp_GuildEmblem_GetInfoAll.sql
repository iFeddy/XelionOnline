USE [w00_Character]
GO
/****** Object:  StoredProcedure [dbo].[usp_GuildEmblem_GetInfoAll]    Script Date: 11/5/2018 10:39:27 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GuildEmblem_GetInfoAll]

AS
BEGIN
	SET NOCOUNT ON
	SELECT nGuildNo, nColor, nIcon, dCreated, dUpdated, nUnk FROM tGuildEmblem
	SET NOCOUNT OFF
END