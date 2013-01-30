-- exec.lua
--[[
	NSExec�����㏑�����郂�W���[��
]]
do
	-- �����̊֐��̏㏑��
	local oNSExec = NSExec
	NSExec = function(com)
		-- �O�ׂ̈ɕ�����
		com = convert(com, "string")
		write_log("NSExec", com)
		oNSExec(com)
	end

	-- ���̃��W���[���Ŏg���ϐ����擾���Ċi�[���Ă����e�[�u��
	local int_vars = {}
	local str_vars = {}
	-- �ϐ����擾����B
	for i=1, 20 do
		int_vars[#int_vars+1] = get_int()
		str_vars[#str_vars+1] = get_str()
	end

	-- �ϐ����񂷊֐�
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

	-- ���s�֐��̒��Ŏg���T�u�֐�
	
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

	-- ���l���擾����ꍇ�́A���̊֐��������ɂ���B
	iRet = function(arg, ret)
		local int = choose_int()
		arg[#arg+1] = "%"..rawget(int, "num")
		ret[#ret+1] = int
	end
	
	-- ��������擾����ꍇ�́A���̊֐��������ɂ���B
	sRet = function(arg, ret)
		local str = choose_str()
		arg[#arg+1] = "$"..rawget(str, "num")
		ret[#ret+1] = str
	end
	
	-- ���̕�������o�͂���ꍇ�́A���̊֐������s�������ʂ������ɂ���B
	Bareword = function(word)
		return function(arg, ret) arg[#arg+1] = word end
	end
	

	-- ���s����֐�
	local nsexec = function(com, ...)
		-- �����������߂���B
		local arg = {}
		local ret = {}
		for i, v in ipairs({...}) do
			sub_nsexec[type(v)](v, arg, ret)
		end

		-- ���s�������B
		local str = "_"..com
		if #arg > 0 then str = str.." "..table.concat(arg, ",") end
		
		-- ���s����B
		NSExec(str)
		
		-- ���ʂ�Ԃ��B
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

	-- ���߂̃I�u�W�F�N�g���Ǘ�����I�u�W�F�N�g
	exec = setmetatable({}, mt)
end
