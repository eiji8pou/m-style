-- luasub.lua
do
	-- 宣言したluasubを保存する。
	local luasub_list = {}
	
	local mt = {}
	
	luasub = setmetatable({}, mt)
	
	-- luasub宣言
	mt.__call = function(com, func, opt)
		if luasub_list[com] then
			if not(opt) then
				die(com.."命令は既に宣言されています。", "luasub")
			end
		else
			exec.luasub(Bareword(com)) -- NSExec("_luasub "..com)
		end
		luasub_list[com] = func
		_G["NSCOM_"..com] = func
	end
	
	mt.__newindex = function(this, com, func, opt)
		mt.__call(com, func, opt)
	end
end
--[[
	使い方
	
	luasubで新しい命令を宣言する。
	
	luasub.new_command_name = func
	
	funcには、関数が期待され、この関数は中で自前で引数処理をすることが期待されている。
]]
