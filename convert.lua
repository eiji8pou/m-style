--convert.lua
--[[
	�^�̈Ⴄ���̂�K���ɖ������ϊ�����֐���񋟂���B
]]

do

	-- �X�̕ϊ��Ɏg���֐����i�[����B
	local lib = {}

	-- �ėp�I�Ɏg����
	local return_nil   = function() return nil end
	local return_true  = function() return true end
	local return_false = function() return false end
	local boomerang = function(ob) return ob end
	local recursion = function(ob, target)
		local ret = ob()
		return lib[target][type(ret)](ret)
	end
	local return_zero = function() return 0 end
	local return_pack = function(ob) return function() return ob end end
	
	-- target��nil�̏ꍇ�B������nil�ɕϊ�����B
	lib["nil"] = {}
	lib["nil"]["nil"]      = return_nil
	lib["nil"]["boolean"]  = return_nil
	lib["nil"]["number"]   = return_nil
	lib["nil"]["string"]   = return_nil
	lib["nil"]["table"]    = return_nil
	lib["nil"]["function"] = return_nil
	lib["nil"]["thread"]   = return_nil
	lib["nil"]["userdata"] = return_nil
	-- �������Ă�nil�ɂȂ�Bw
	
	-- target��boolean�̏ꍇ�B������boolean�ɕϊ�����B
	lib["boolean"] = {}
	lib["boolean"]["nil"]      = return_false
	lib["boolean"]["boolean"]  = boomerang
	lib["boolean"]["number"]   = function(ob) return ob==0       and false or true end
	lib["boolean"]["string"]   = function(ob) return ob:len()==0 and false or true end
	lib["boolean"]["table"]    = function(ob) return #ob==0      and false or true end
	lib["boolean"]["function"] = function(ob) return recursion(ob, "boolean") end
	lib["boolean"]["thread"]   = return_true
	lib["boolean"]["userdata"] = return_true
	
	-- target��number�̏ꍇ�B������number�ɕϊ�����B
	lib["number"] = {}
	lib["number"]["nil"]       = return_zero
	lib["number"]["boolean"]   = function(ob) return ob and 1 or 0 end
	lib["number"]["number"]    = boomerang
	lib["number"]["string"]    = tostring
	lib["number"]["table"]     = function(ob) return #ob end
	lib["number"]["function"]  = function(ob) return recursion(ob, "number") end
	lib["number"]["thread"]    = return_zero
	lib["number"]["userdata"]  = return_zero
	
	-- target��string�̏ꍇ�B������string�ɕϊ�����B
	lib["string"] = {}
	lib["string"]["nil"]      = function() return "nil" end
	lib["string"]["boolean"]  = function(ob) return ob and "true" or "false" end
	lib["string"]["number"]   = tonumber
	lib["string"]["string"]   = boomerang
	lib["string"]["table"]    = Json.Encode
	lib["string"]["function"] = function(ob) return recursion(ob, "function") end
	lib["string"]["thread"]   = function() return "thread" end
	lib["string"]["userdata"] = function() return "userdata" end
	
	-- target��function�̏ꍇ�B�����Ԃ�function�ɕϊ�����B
	lib["function"] = {}
	lib["function"]["nil"]      = return_pack
	lib["function"]["boolean"]  = return_pack
	lib["function"]["number"]   = return_pack
	lib["function"]["string"]   = return_pack
	lib["function"]["function"] = boomerang
	lib["function"]["function"] = return_pack
	lib["function"]["thread"]   = return_pack
	lib["function"]["userdata"] = return_pack
	
	-- �ėp�̕ϊ��֐�
	convert = function(ob, target)
		-- ob�͕ϊ����B
		-- target�͕ϊ���̌^�Bnumber, string, boolean, function
		target = target or "nil" -- target���w�肵�Ȃ���nil�ɂ����Ⴄ��B
		local sub_lib = lib[target]
		if sub_lib then
			return sub_lib[type(ob)](ob)
		else
			die("�ϊ���̌^���s���ł��B", "convert")
		end
	end

	-- �ϊ��֐��̃V���[�g�J�b�g�����B
	-- �Ⴆ�΁Aboolean��number�ɕϊ�����ꍇ�́Abool2num�֐����g���B
	-- ���l�ɁA�^���̗��͉̂��L�̂Ƃ���B

	-- �^���̗���
	local elp = {}
	elp["nil"]      = "nil"
	elp["boolean"]  = "bool"
	elp["number"]   = "num"
	elp["string"]   = "str"
	elp["table"]    = "t"
	elp["function"] = "func"
	elp["thread"]   = "thread"
	elp["userdata"] = "userdata"

	for target, func_list in pairs(lib) do
		for from, func in pairs(func_list) do
			-- �����֐���
			local func_name = elp[from].."2"..elp[target]
			-- �֐����`
			_G[func_name] = function(ob)
				if type(ob) ~= from then error("�ϊ����̌^���s���ł��B", func_name) end
				return convert(ob, target)
			end
		end
	end
end
