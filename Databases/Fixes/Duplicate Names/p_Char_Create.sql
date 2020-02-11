USE [w00_Character]
GO
/****** Object:  StoredProcedure [dbo].[p_Char_Create]    Script Date: 10/13/2018 5:54:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Character Create 
2004.6 By CJC
 input:
   All Args
 output: 
   nCharNo = 1~? 생성된 캐릭의 번호(에러시 = 0 )
           =  0 캐릭 생성 에러
           = -1 해당 유저의 슬롯에 캐릭이 있음.
           = -2 캐릭 외모 기록 에러
           = -3 캐릭 옵션 기록 에러
2010.10.7 By kodong
  신규 단축키 시스템 추가로 인한 프로시저 수정
*/
ALTER PROCEDURE [dbo].[p_Char_Create] 
	@nUserNo int,			-- 1	1 ~ ?
	@nCreateWorld tinyint,	-- 2	0 ~ ?
	@nAdminLevel tinyint,	-- 3	0=USER, 1~?=GM Level 1~?
	@nSlotNo tinyint,		-- 4	0 ~ 5
	@sID nvarchar(40),		-- 5  
	@nRace tinyint,			-- 6	0 = Human, 1 = Elf, 2 = Dark elf
	@nClass tinyint,		-- 7	1 = Fighter,4 = Cleric, 7 = Archer, 10 = Mage
	@nGender tinyint,		-- 8	0 = Male, 1 = Female
	@nHairType tinyint,		-- 9	0 ~ ?
	@nHairColor tinyint,	-- 10	0 ~ ?
	@nFaceShape tinyint,	-- 11	0 ~ ?
	@nCharNo int OUTPUT     -- 12
AS
BEGIN
	SET NOCOUNT ON
	-- 에러코드 일단 세팅
	SET @nCharNo = 0
	-- 해당유저의 해당슬롯에 캐릭이 있는지 확인
	IF EXISTS (SELECT nUserNo FROM tCharacter(NOLOCK) WHERE nUserNo = @nUserNo AND nSlotNo = @nSlotNo AND bDeleted = 0)
	BEGIN
		SET @nCharNo = -1
		RETURN
	END
	-- 캐릭 생성
	
	IF EXISTS (SELECT sID FROM tCharacter(NOLOCK) WHERE sID = @sID)
		BEGIN
		RETURN
		END
		ELSE
	-- 캐릭 생성
	
	BEGIN TRAN
	IF EXISTS (SELECT sID FROM tCharacter(NOLOCK) WHERE sID = @sID)
		BEGIN
		RETURN
		END
		ELSE
	INSERT tCharacter (  nUserNo,  nSlotNo,  sID,  nCreateWorld,  nAdminLevel )
	VALUES            ( @nUserNo, @nSlotNo, @sID, @nCreateWorld, @nAdminLevel )
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	SET @nCharNo = @@IDENTITY
	-- 캐릭 외모 세팅
	INSERT tCharacterShape (  nCharNo,  nRace,  nClass,  nGender,  nHairType,  nHairColor,  nFaceShape )
	VALUES                 ( @nCharNo, @nRace, @nClass, @nGender, @nHairType, @nHairColor, @nFaceShape ) 
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		SET @nCharNo = -2
		RETURN
	END
	-- 캐릭 옵션 세팅
	INSERT tCharacterOptions (  nCharNo )
	VALUES                   ( @nCharNo )
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		SET @nCharNo = -3
		RETURN
	END
	-- 캐릭 생성 성공

	-- 2010.10.7
	-- kodong
	-- 새로 추가된 단축키 시스템에 의해 초기값 지정
	DECLARE @nRet int
	SET @nRet = 0
	EXEC usp_Character_initKeyMap @nCharNo, @nRet output
	IF @@ERROR <> 0 OR @nRet <> 0 BEGIN
		ROLLBACK TRAN
		SET @nCharNo = -4
		RETURN
	END
	ELSE BEGIN
		COMMIT TRAN
	END
END

