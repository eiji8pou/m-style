-- luasub.lua
do
	-- �錾����luasub��ۑ�����B
	local luasub_list = {}
	
	local mt = {}
	
	luasub = setmetatable({}, mt)
	
	-- luasub�錾
	mt.__call = function(com, func, opt)
		if luasub_list[com] then
			if not(opt) then
				die(com.."���߂͊��ɐ錾����Ă��܂��B", "luasub")
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
	�g����
	
	luasub�ŐV�������߂�錾����B
	
	luasub.new_command_name = func
	
	func�ɂ́A�֐������҂���A���̊֐��͒��Ŏ��O�ň������������邱�Ƃ����҂���Ă���B
]]
