-- exec.lua
--[[
	NSExec等を上書きするモジュール
]]
do
	-- 既存の関数の上書き
	local oNSExec = NSExec
	NSExec = function(com)
		-- 念の為に文字列化
		com = convert(com, "string")
		write_log("NSExec", com)
		oNSExec(com)
	end

	-- このモジュールで使う変数を取得して格納しておくテーブル
	local int_vars = {}
	local str_vars = {}
	-- 変数を取得する。
	for i=1, 20 do
		int_vars[#int_vars+1] = get_int()
		str_vars[#str_vars+1] = get_str()
	end

	-- 変数を回す関数
	local choose_int = function()
		local ret = table.remove(int_vars, 1)
		int_vars[#int_vars+1] = ret
		return ret
	end
	local choose_str = function()
		local ret = table.remove(str_vars, 1)
		str_vars[#str_vars+1] = ret
		return ret
	end

	-- 実行関数の中で使うサブ関数
	
	local sub_nsexec = {}
	sub_nsexec["nil"]      = function(v, arg, ret) arg[#arg+1] = "" end
	sub_nsexec["boolean"]  = function(v, arg, ret) arg[#arg+1] = num2str(bool2num(v)) end
	sub_nsexec["number"]   = function(v, arg, ret) arg[#arg+1] = num2str(v) end
	sub_nsexec["string"]   = function(v, arg, ret)
		local str = choose_str()
		str(v)
		arg[#arg+1] = "$"..rawget(str, "num")
	end
	sub_nsexec["table"]    = sub_nsexec["string"]
	sub_nsexec["function"] = function(v, arg, ret) v(arg, ret) end
	sub_nsexec["thread"]   = sub_nsexec["nil"]
	sub_nsexec["userdata"] = sub_nsexec["nil"]

	-- 数値を取得する場合は、この関数を引数にする。
	iRet = function(arg, ret)
		local int = choose_int()
		arg[#arg+1] = "%"..rawget(int, "num")
		ret[#ret+1] = int
	end
	
	-- 文字列を取得する場合は、この関数を引数にする。
	sRet = function(arg, ret)
		local str = choose_str()
		arg[#arg+1] = "$"..rawget(str, "num")
		ret[#ret+1] = str
	end
	
	-- 裸の文字列を出力する場合は、この関数を実行した結果を引数にする。
	Bareword = function(word)
		return function(arg, ret) arg[#arg+1] = word end
	end
	

	-- 実行する関数
	local nsexec = function(com, ...)
		-- 引数等を解釈する。
		local arg = {}
		local ret = {}
		for i, v in ipairs({...}) do
			sub_nsexec[type(v)](v, arg, ret)
		end

		-- 実行文を作る。
		local str = "_"..com
		if #arg > 0 then str = str.." "..table.concat(arg, ",") end
		
		-- 実行する。
		NSExec(str)
		
		-- 結果を返す。
		local res = {}
		for i, v in ipairs(ret) do res[i] = v() end
		return unpack(res)
	end

	local mt = {}
	mt.__newindex = function() end
	mt.__index = function(this, com)
		rawset(this, com, function(...) return nsexec(com, ...) end)
		return rawget(this, com)
	end

	-- 命令のオブジェクトを管理するオブジェクト
	exec = setmetatable({}, mt)
end
