USE [w00_Character]
GO

/****** Object:  Table [dbo].[tGuildHistory]    Script Date: 3/06/2019 16:37:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tGuildHistory](
    [nGuildID] [int] NOT NULL,
    [nCharNo] [int] NOT NULL,
    [sID] [nvarchar](50) NOT NULL,
    [dDate] [datetime] NOT NULL,
    [nAction] [int] NOT NULL
) ON [PRIMARY]
GO