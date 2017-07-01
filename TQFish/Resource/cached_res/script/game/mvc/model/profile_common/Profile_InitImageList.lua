module(..., package.seeall)

local InitImageList = {}

--[[--
--加载本地初始化的图片列表
]]
local function loadInitImageListTable()

	InitImageList = Common.LoadTable("InitImageList")
	if InitImageList == nil then
		InitImageList = {}
		InitImageList["TimeStamp"] = 0
		InitImageList["picList"] = {}
	end
end

loadInitImageListTable()

--[[--
--获取要初始化的图片列表
--]]
function getInitImageList()
	return InitImageList["picList"];
end

--[[--
--获取要初始化的图片列表时间戳
--]]
function getInitImageListTimestamp()
	return InitImageList["TimeStamp"];
end

--[[-- 解析获取初始化图片]]
function readMANAGERID_GET_INIT_PIC(dataTable)
	if InitImageList["TimeStamp"] ~= dataTable["TimeStamp"] then
		InitImageList["TimeStamp"] = dataTable["TimeStamp"]
		InitImageList["picList"] = dataTable["picList"]
		Common.SaveTable("InitImageList", InitImageList)
	end

	framework.emit(MANAGERID_GET_INIT_PIC)
end

registerMessage(MANAGERID_GET_INIT_PIC, readMANAGERID_GET_INIT_PIC)