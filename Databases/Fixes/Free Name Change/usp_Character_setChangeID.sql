USE [w00_Character]
GO
/****** Object:  StoredProcedure [dbo].[usp_Character_setChangeID]    Script Date: 12/9/2018 10:01:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*--------------------------------------------------------------------------------------
' 이  름 : usp_Character_setChangeID
' 작성자 : Ko Dong Gyun(kodong@gmail.com)
' 작성일 : 2010.7.7.
' Description :
'   캐릭터명을 변경하는 프로시저
'	인간관계 초기화 설정시 친구, 결혼, 길드, 홀리프라미스, 채팅블럭, 길드아카데미
'	정보를 초기화 한다.
' Parameter :
'	input Parameter
'		@nRowNo  : 일련번호
'		@nCharNo : 캐릭터번호
'		@sID     : 변경된 캐릭터명
'		@bInit   : 인간관계 초기화여부
'		@nUserNo : 유저번호
'	output Parameter
'		@nRet	 : check SQL execute(valid/invalid)
'			= 0	 : works ok
'			< 0	 : error
'				-3023 : 선택한 캐릭터는 삭제된 캐릭터이거나 존재하지 않는 캐릭터입니다.
'				-3024 : 입력된 유저번호와 실제 유저번호가 일치하지 않습니다.
'				-3025 : 길드마스터는 인간관계 초기화를 할 수 없습니다.
'				-3026 : 캐릭터명 변경 오류입니다. db error (update)
'				-3027 : 친구 정보 삭제 오류입니다.
'				-3028 : 결혼 정보 삭제 오류입니다.
'				-3029 : 홀리프라미스 정보 삭제 오류입니다. 하위관계
'				-3030 : 홀리프라미스 정보 삭제 오류입니다. 상위관계
'				-3031 : 채팅 블록 정보 삭제 오류입니다.
'				-3032 : 길드아카데미 정보의 길드아카데미 마스터 정보 갱신 오류입니다.
'				-3033 : 길드 정보 삭제 오류입니다.
'				-3034 : 길드아카데미 정보 삭제 오류입니다.
'				-3035 : 캐릭터명 변경 서비스 반영여부 갱신 오류입니다.
'				-3039 : 이미 사용중인 캐릭터명입니다.
'-------------------------------------------------------------------------------------*/
ALTER PROCEDURE [dbo].[usp_Character_setChangeID]
	@nRowNo  int
,	@nCharNo int
,	@sID     nvarchar(16)
,	@bInit   bit
,	@nUserNo int
,	@nRet    int = 0 output
AS
BEGIN
	SET NOCOUNT ON

	SET @nRet = 0
	
	DECLARE @sOldID AS nvarchar(50)
	DECLARE @nDBUserNo AS int
	DECLARE @nGrade AS tinyint
	DECLARE @nMyGuildNo AS int
	
	SELECT @sOldID = T1.sID, @nDBUserNo = T1.nUserNo, @nGrade = nGrade
	  FROM tCharacter T1 LEFT OUTER JOIN tGuildMember T2 ON T1.nCharNo = T2.nCharNo
	 WHERE T1.nCharNo = @nCharNo AND T1.bDeleted = 0
	   AND bDeleted = 0
	IF @sOldID = @sID BEGIN
		SET @nRet = -3039
		RETURN
	END	
	IF @nDBUserNo IS NULL BEGIN
		SET @nRet = -3023
		RETURN
	END
	ELSE BEGIN
		-- mismatch userNo
		IF @nDBUserNo <> @nUserNo BEGIN
			SET @nRet = -3024
			RETURN
		END
		
		-- impossible guildmaster
		IF @nGrade IS NOT NULL AND @nGrade = 0 AND @bInit = 1 BEGIN
			SET @nRet = -3025
			RETURN
		END

		IF NOT EXISTS(SELECT nCharNo FROM tCharacterChangeID WHERE bFlag = 0 AND nCharNo = @nCharNo) BEGIN
			SET @nRet = -3024
			RETURN
		END

		BEGIN TRAN
		
		-- change ID
		IF EXISTS(SELECT nCharNo FROM tCharacter WHERE sID = @sID) BEGIN		
			SET @nRet = -3039
			ROLLBACK TRAN
			RETURN
		END
		ELSE BEGIN
			UPDATE tCharacter
			   SET sID = @sID
			 WHERE nCharNo = @nCharNo
			IF @@ERROR <> 0 OR @@ROWCOUNT <> 1 BEGIN
				SET @nRet = -3026
				ROLLBACK TRAN
				RETURN
			END		
		END
		
		-- init Community
		IF @bInit = 1 BEGIN
			-- delete Friend
			IF EXISTS(SELECT nCharNo FROM tFriend WHERE nCharNo = @nCharNo) BEGIN
				DELETE FROM tFriend WHERE nCharNo = @nCharNo
				IF @@ERROR <> 0 OR @@ROWCOUNT < 1 BEGIN
					SET @nRet = -3027
					ROLLBACK TRAN
					RETURN
				END
			END
			IF EXISTS(SELECT nCharNo FROM tFriend WHERE nFriendCharNo = @nCharNo) BEGIN
				DELETE FROM tFriend WHERE nFriendCharNo = @nCharNo
				IF @@ERROR <> 0 OR @@ROWCOUNT < 1 BEGIN
					SET @nRet = -3027
					ROLLBACK TRAN
					RETURN
				END				
			END
			
			-- delete Marriage
			IF EXISTS(SELECT nCharNo FROM tMarriage WHERE nCharNo = @nCharNo) BEGIN
				DELETE FROM tMarriage WHERE nCharNo = @nCharNo
				IF @@ERROR <> 0 OR @@ROWCOUNT < 1 BEGIN
					SET @nRet = -3028
					ROLLBACK TRAN
					RETURN
				END
			END
			IF EXISTS(SELECT nCharNo FROM tMarriage WHERE nPartnerCharNo = @nCharNo) BEGIN				
				DELETE FROM tMarriage WHERE nPartnerCharNo = @nCharNo
				IF @@ERROR <> 0 OR @@ROWCOUNT < 1 BEGIN
					SET @nRet = -3028
					ROLLBACK TRAN
					RETURN
				END				
			END			

			-- delete HolyPromise me
			IF EXISTS(SELECT nCharNo FROM tHolyPromise WHERE nCharNo = @nCharNo) BEGIN
				DELETE FROM tHolyPromise WHERE nCharNo = @nCharNo
				IF @@ERROR <> 0 OR @@ROWCOUNT < 1 BEGIN
					SET @nRet = -3029
					ROLLBACK TRAN
					RETURN
				END
			END
			
			-- delete HolyPromise up
			IF EXISTS(SELECT nCharNo FROM tHolyPromise WHERE nUpCharNo = @nCharNo) BEGIN
				DELETE FROM tHolyPromise WHERE nUpCharNo = @nCharNo
				IF @@ERROR <> 0 OR @@ROWCOUNT < 1 BEGIN
					SET @nRet = -3030
					ROLLBACK TRAN
					RETURN
				END
			END			
			
			-- delete ChatBlock
			IF EXISTS(SELECT nCharNo FROM tChatBlock WHERE nCharNo = @nCharNo) BEGIN
				DELETE FROM tChatBlock WHERE nCharNo = @nCharNo
				IF @@ERROR <> 0 OR @@ROWCOUNT < 1 BEGIN
					SET @nRet = -3031
					ROLLBACK TRAN
					RETURN
				END
			END			
						
			-- delete GuildAcademyMaster & GuildMember		
			SELECT @nMyGuildNo = nNo FROM tGuildMember WHERE nCharNo = @nCharNo
			IF @nMyGuildNo IS NOT NULL BEGIN
				IF EXISTS(SELECT nNo FROM tGuildAcademy WHERE nNo = @nMyGuildNo AND nMasterCharNo = @nCharNo) BEGIN
					-- reset GuildAcademy Master
					UPDATE tGuildAcademy
					   SET nMasterCharNo = (SELECT TOP 1 nCharNo FROM tGuildMember WHERE nNo = @nMyGuildNo AND nGrade = 0)
					 WHERE nNo = @nMyGuildNo
					IF @@ERROR <> 0 OR @@ROWCOUNT <> 1 BEGIN
						SET @nRet = -3032
						ROLLBACK TRAN
						RETURN
					END						 
				END
				-- delete GuildMember
				DELETE FROM tGuildMember WHERE nCharNo = @nCharNo
				IF @@ERROR <> 0 OR @@ROWCOUNT <> 1 BEGIN
					SET @nRet = -3033
					ROLLBACK TRAN
					RETURN
				END
			END
			
			-- delete GuildAcademyMember
			IF EXISTS(SELECT nCharNo FROM tGuildAcademyMember WHERE nCharNo = @nCharNo) BEGIN
				DELETE FROM tGuildAcademyMember WHERE nCharNo = @nCharNo
				IF @@ERROR <> 0 OR @@ROWCOUNT <> 1 BEGIN
					SET @nRet = -3034
					ROLLBACK TRAN
					RETURN
				END	
			END				
		END

		UPDATE tCharacterChangeID 
		   SET sys_update_date = GETDATE(), bFlag = 1, sOldID = @sOldID, sNewID = @sID
		 WHERE nRowNo = @nRowNo 
		IF @@ERROR <> 0 OR @@ROWCOUNT <> 1 BEGIN
			SET @nRet = -3035
			ROLLBACK TRAN
			RETURN
		END
				
		COMMIT TRAN
	END

	SET NOCOUNT OFF
END

