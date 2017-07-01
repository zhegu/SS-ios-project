module(..., package.seeall)

local UserLoginRegInfo = {}

UserLoginRegInfo["Result"] = 2 -- 2是初始值，0是成功 1是失败
UserLoginRegInfo["ResultText"] = ""
UserLoginRegInfo["LoginWithMore"] = ""

--[[--
--Result
]]
function getResult()
	local value = UserLoginRegInfo["Result"]
	if value == nil then
		return 2
	else
		return value
	end
end

function setResult(result)
	UserLoginRegInfo["Result"] = result
end

--[[--
--ResultText
]]
function getResultText()
	local value = UserLoginRegInfo["ResultText"]
	if value == nil then
		return ""
	else
		return value
	end
end

function setResultText(resultText)
	UserLoginRegInfo["ResultText"] = resultText
end

--[[--
--LastUserLogin
]]
function getLastLoginUsername()
	local value = UserLoginRegInfo["LastLoginUsername"]
	if value == nil then
		return ""
	else
		return value
	end
end

function setLastLoginUsername(lastLoginUsername)
	UserLoginRegInfo["LastLoginUsername"] = lastLoginUsername
end

--[[--
--LoginWithMore
--]]
function getLoginWithMore()
	local value = UserLoginRegInfo["LoginWithMore"]
	if value == nil then
		return ""
	else
		return value
	end
end

function setLoginWithMore(loginWithMore)
	UserLoginRegInfo["LoginWithMore"] = loginWithMore
end

--[[--
--获取登录/注册信息
--]]
function getBaseInfo()
	local value = UserLoginRegInfo["BaseInfo"]
	if value == nil then
		return ""
	else
		return value
	end
end
--[[--
--获得未读消息数量
--]]
function getUnreadMsgCnt()
	return UserLoginRegInfo["BaseInfo"].UnreadMsgCnt
end

--[[--
--登录消息处理
--]]
function setLoginSucess(dataTable)
	local result = dataTable["result"]
	local resultText = dataTable["ResultTxt"]
	local lastLoginUsername = dataTable["NickName"]
	UserLoginRegInfo["Result"] = result
	UserLoginRegInfo["ResultText"] = resultText
	UserLoginRegInfo["LastLoginUsername"] = lastLoginUsername

	UserLoginRegInfo["BaseInfo"] = {}
	UserLoginRegInfo["BaseInfo"].UserID = dataTable["UserID"]
	UserLoginRegInfo["BaseInfo"].NickName = dataTable["NickName"] --NickName  昵称
	Common.log("登录消息处理 nickName == "..UserLoginRegInfo["BaseInfo"].NickName)
	UserLoginRegInfo["BaseInfo"].PhotoUrl = dataTable["PhotoUrl"]
	UserLoginRegInfo["BaseInfo"].Coin = dataTable["Coin"] --Coin  金币
	UserLoginRegInfo["BaseInfo"].YuanBao = dataTable["yuanbao"] --yuanbao  元宝
	UserLoginRegInfo["BaseInfo"].InitLoginInfoChanged = dataTable["InitLoginInfoChanged"] --InitLoginInfoChanged  是否修改过原始登录信息
	UserLoginRegInfo["BaseInfo"].UnreadMsgCnt = dataTable["UnreadMsgCnt"] --UnreadMsgCnt  未读消息数量
	if dataTable["UnreadMsgCnt"] >0 then
		profileCommon.Message.readisHallMessage_isRed()
	end
	UserLoginRegInfo["BaseInfo"].SessionID = dataTable["SessionID"] --SessionID  当前Socket连接的SessionID
	UserLoginRegInfo["BaseInfo"].VipLevel = dataTable["VipLevel"]
	--ThirdPartPlatId	Int	第三方登录平台的id	0自有渠道登录 15 wechat登录 16 Facebook 登录
	UserLoginRegInfo["BaseInfo"].thirdPartPlatId = dataTable["thirdPartPlatId"]
	Common.log("thirdPartPlatId ========== " .. UserLoginRegInfo["BaseInfo"].thirdPartPlatId)

	profile.User.setSelfUserID(UserLoginRegInfo["BaseInfo"].UserID)
	profile.User.setSelfNickName(UserLoginRegInfo["BaseInfo"].NickName)
	profile.User.setSelfPhotoUrl(UserLoginRegInfo["BaseInfo"].PhotoUrl)
	profile.User.setSelfCoin(UserLoginRegInfo["BaseInfo"].Coin)
	profile.User.setSelfYuanBao(UserLoginRegInfo["BaseInfo"].YuanBao)
	--	profile.User.setSelfVipLevel(UserLoginRegInfo["BaseInfo"].VipLevel)
	profile.User.setSelfVipLevel(0);
		profile.User.setUserThirdPartPlatId(UserLoginRegInfo["BaseInfo"].thirdPartPlatId)

	framework.emit(BASEID_LOGIN)
end

--[[--
--读取第三方渠道登录
--]]
function readBASEID_THIRD_PART_PLAT_LOGIN(dataTable)
	Common.log("readBASEID_THIRD_PART_PLAT_LOGIN")
	Common.log("Password = "..dataTable["Password"])
	Common.log("IsRegister = "..dataTable["IsRegister"])
	--保存用户信息
	profile.User.setSelfPassword(dataTable["Password"]);
	LoginConfig.saveUserData();
end

--[[--
--注册消息处理
--]]
function setRegSucess(dataTable)
	local result = dataTable["Result"]
	local resultText = dataTable["ResultTxt"]
	local lastLoginUsername = dataTable["NickName"]
	UserLoginRegInfo["Result"] = result
	UserLoginRegInfo["ResultText"] = resultText
	UserLoginRegInfo["LastLoginUsername"] = lastLoginUsername

	UserLoginRegInfo["BaseInfo"] = {}
	UserLoginRegInfo["BaseInfo"].UserID = dataTable["UserID"]
	UserLoginRegInfo["BaseInfo"].NickName = dataTable["NickName"]
	Common.log("注册消息处理 nickName == "..UserLoginRegInfo["BaseInfo"].NickName)
	UserLoginRegInfo["BaseInfo"].Password = dataTable["Password"]
	Common.log("注册消息处理 Password == "..UserLoginRegInfo["BaseInfo"].Password)
	UserLoginRegInfo["BaseInfo"].PhotoUrl = dataTable["PhotoUrl"]
	UserLoginRegInfo["BaseInfo"].Coin = dataTable["Coin"]
	UserLoginRegInfo["BaseInfo"].YuanBao = dataTable["YuanBao"]
	UserLoginRegInfo["BaseInfo"].honor = dataTable["honor"] --honor  荣誉值
	UserLoginRegInfo["BaseInfo"].SessionID = dataTable["SessionID"] --SessionID  当前Socket连接的SessionID

	--ThirdPartPlatId	Int	第三方登录平台的id	0自有渠道登录 15 wechat登录 16 Facebook 登录
	UserLoginRegInfo["BaseInfo"].thirdPartPlatId = 0;

	profile.User.setSelfUserID(UserLoginRegInfo["BaseInfo"].UserID)
	profile.User.setSelfNickName(UserLoginRegInfo["BaseInfo"].NickName)
	profile.User.setSelfPassword(UserLoginRegInfo["BaseInfo"].Password)
	profile.User.setSelfPhotoUrl(UserLoginRegInfo["BaseInfo"].PhotoUrl)
	profile.User.setSelfCoin(UserLoginRegInfo["BaseInfo"].Coin)
	profile.User.setSelfYuanBao(UserLoginRegInfo["BaseInfo"].YuanBao)
	profile.User.setUserThirdPartPlatId(UserLoginRegInfo["BaseInfo"].thirdPartPlatId)

	framework.emit(BASEID_REGISTER)
end

function updateImei(dataTable)
	local IsSuccess = dataTable["IsSuccess"];
	if IsSuccess == 1 then
		Common.log("更新IMEI===============成功")
		Common.setDataForSqlite(CommSqliteConfig.IOS_APPSTORE_IDFA, Common.getIDFA());
	end
end

registerMessage(BASEID_LOGIN, setLoginSucess)
registerMessage(BASEID_REGISTER, setRegSucess)
registerMessage(COMMONS_UPDATE_IMEI, updateImei)
registerMessage(BASEID_THIRD_PART_PLAT_LOGIN, readBASEID_THIRD_PART_PLAT_LOGIN)
