-- luacall.lua
do
	-- luacallの対象
	local call_list = {
		"animation",
		"close",
		"end",
		"load",
		"reset",
		"save",
		"savepoint",
		"tag",
		"text",
		"text0"
	}

	-- luacallされた時に使う関数のリスト
	local func_list = {}

	-- luacallに実行する関数を登録する。
	function add_luacall(call_name, func)
		-- 初めての登録なら
		if not(call_list[call_name]) then
			call_list[call_name] = {func} -- 登録する。
			NSExec("_luacall "..call_name) -- 使用を宣言する。
			_G["NSCALL_"..call_name] = function()
				for i, func in ipairs(call_list[call_name]) do
					func()
				end
			end
		else
			call_list[call_name][#call_list[call_name]+1] = func -- 登録する。
		end
	end

end
