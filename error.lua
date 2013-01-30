-- error.lua
--[[
	�G���[���b�Z�[�W���ȈՉ����郂�W���[��
]]
do
	-- NSOkBox��NSYesNoBox���㏑������B
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

	-- �x���̃��b�Z�[�W���o�������B
	-- ������NSOkBox�Ɠ��������A�ȗ��ł���B
	alert = function(mes,cap)
		NSOkBox(mes, cap)
		write_stack()
	end

	-- �x���̃��b�Z�[�W���o���āAYes�Ȃ�I������B
	function warning(mes, cap)
		local ret = NSYesNoBox(mes, cap)
		write_stack()
		if ret then NSEnd() end
		return ret
	end
	
	-- ���݂̊֐��̌ďo�󋵂�Ԃ��֐��B
	local stack_tracer = function()
		local stack = {}
		local stack_count = 1
		while true do
			local level = debug.getinfo(stack_count, "n")
			if type(level) == "nil" then break end
			stack[#stack+1] = level.name
			stack_count = stack_count + 1
		end
		table.remove(stack, 1) -- �擪�����O
		table.remove(stack, 1) -- �擪�����O
		return stack
	end
	
	-- ���݂̊֐��̌ďo�󋵂��L�^����֐��B
	write_stack = function()
		write_log("���s���̊֐���", stack_tracer())
	end
	
	-- �G���[���b�Z�[�W���o���ďI������B
	-- �����͏ȗ��ł���B
	function die(mes, cap)
		alert(mes, cap)
		write_log("���s���̊֐���", stack_tracer())
		NSEnd()
	end
	
	-- �e�X�g�X�N���v�g�̓o�^
	test_functions.error = function()
		NSOkBox(
			stack_tracer(),
			"�X�^�b�N"
		)
	end
end

--[[
	�O�̊֐���_G�ɒǉ�����B
	
	alert	�x�����o���B
	warning �x�����o������ŁA�I�����邩�₤�B
	die	�x�����o���āA�����I�ɏI������B
]]
