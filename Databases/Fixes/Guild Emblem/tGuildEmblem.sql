USE [w00_Character]
GO

/****** Object:  Table [dbo].[tGuildEmblem]    Script Date: 3/06/2019 16:37:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tGuildEmblem](
	[nGuildNo] [int] NOT NULL,
	[nColor] [int] NOT NULL,
	[nIcon] [int] NOT NULL,
	[dCreated] [datetime] NOT NULL,
	[dUpdated] [datetime] NOT NULL,
	[nUnk] [int] NOT NULL
) ON [PRIMARY]
GO


