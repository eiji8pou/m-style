-- dll.lua
--[[
	lua側から、NScripter側のDLL呼出と結果取得を簡単にする。
]]
do
	-- DLL呼出は、exec_dllとgetretの対になるのが基本
	
	-- 予め取得しておく。
	local exec_dll_func = exec.exec_dll
	local getret_func = exec.getret
	
	-- exec_dll
	-- 第一引数がDLL名
	-- 第二引数が引数の区切り文字
	-- 第三引数以降は全て引数
	function exec_dll(dll_name, separater, ...)
		local str = dll_name
		local arg = {...}
		if #arg > 0 then
			str = str .. "/" .. table.concat(arg, separater)
		end
		exec_dll_func(str)
		-- getretをまとめたもの。数値、文字列の順で返ってくる。
		return getret_func(iRet), getret_func(sRet)
	end

	-- exec_dllを関数オブジェクトにする関数
	local dll_list = {} -- 作ったオブジェクトを保存する何か。
	function make_exec(dll_name, separater)
		dll_list[dll_name] = dll_list[dll_name] or function(...)
			return exec_dll(dll_name, separater, ...)
		end
		return dll_list[dll_name]
	end
end
