-- error.lua
--[[
	エラーメッセージを簡易化するモジュール
]]
do
	-- NSOkBoxとNSYesNoBoxを上書きする。
	local oNSOkBox = NSOkBox
	NSOkBox = function(mes, cap)
		mes = convert(mes, "string")
		cap = convert(cap, "string")
		write_log("NSOkBox", mes, cap)
		oNSOkBox(mes, cap)
	end
	
	local oNSYesNoBox = NSYesNoBox
	NSYesNoBox = function(mes, cap)
		mes = convert(mes, "string")
		cap = convert(cap, "string")
		local ret = oNSYesNoBox(mes, cap)
		write_log("NSYesNoBox", mes, cap, ret)
		return ret
	end

	-- 警告のメッセージを出すだけ。
	-- 引数はNSOkBoxと同じだが、省略できる。
	alert = function(mes,cap)
		NSOkBox(mes, cap)
		write_stack()
	end

	-- 警告のメッセージを出して、Yesなら終了する。
	function warning(mes, cap)
		local ret = NSYesNoBox(mes, cap)
		write_stack()
		if ret then NSEnd() end
		return ret
	end
	
	-- 現在の関数の呼出状況を返す関数。
	local stack_tracer = function()
		local stack = {}
		local stack_count = 1
		while true do
			local level = debug.getinfo(stack_count, "n")
			if type(level) == "nil" then break end
			stack[#stack+1] = level.name
			stack_count = stack_count + 1
		end
		table.remove(stack, 1) -- 先頭を除外
		table.remove(stack, 1) -- 先頭を除外
		return stack
	end
	
	-- 現在の関数の呼出状況を記録する関数。
	write_stack = function()
		write_log("実行中の関数状況", stack_tracer())
	end
	
	-- エラーメッセージを出して終了する。
	-- 引数は省略できる。
	function die(mes, cap)
		alert(mes, cap)
		write_log("実行中の関数状況", stack_tracer())
		NSEnd()
	end
	
	-- テストスクリプトの登録
	test_functions.error = function()
		NSOkBox(
			stack_tracer(),
			"スタック"
		)
	end
end

--[[
	三つの関数を_Gに追加する。
	
	alert	警告を出す。
	warning 警告を出した上で、終了するか問う。
	die	警告を出して、強制的に終了する。
]]
