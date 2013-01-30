-- luacall.lua
do
	-- luacall�̑Ώ�
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

	-- luacall���ꂽ���Ɏg���֐��̃��X�g
	local func_list = {}

	-- luacall�Ɏ��s����֐���o�^����B
	function add_luacall(call_name, func)
		-- ���߂Ă̓o�^�Ȃ�
		if not(call_list[call_name]) then
			call_list[call_name] = {func} -- �o�^����B
			NSExec("_luacall "..call_name) -- �g�p��錾����B
			_G["NSCALL_"..call_name] = function()
				for i, func in ipairs(call_list[call_name]) do
					func()
				end
			end
		else
			call_list[call_name][#call_list[call_name]+1] = func -- �o�^����B
		end
	end

end
