-- stralias.lua
do
	-- ���^�e�[�u�����N���X
	local mt = {}

	-- �V�����l���ݒ肳�ꂽ��
	mt.__newindex = function(ob, index, value)
		-- ���ɒ�`���I����Ă���Ȃ�A�G���[�ɂȂ�B
		if game_start then
			die("����game�����s����Ă��܂��Bstralias���`���邱�Ƃ͂ł��܂���B", "stralias.lua")
		end
		-- �����̃`�F�b�N�B
		arg.command(index, "stralias.lua")
		arg.string(value, "stralias.lua")
		-- stralias�̎��s
		exec.stralias(Bareword(index), value)
		-- stralias�̕ۊ�
		rawset(ob, index, value)
	end
	
	-- �l���Ăяo���ꂽ��
	mt.__index = function(ob, index)
		-- �����̃`�F�b�N�B
		arg.command(index, "stralias.lua")
		-- �����ɗ����ƌ������Ƃ́A���̃��W���[���̒�`���s�Ȃ��Ă��Ȃ��ƌ������ƁB
		-- NScripter���Œ�`����Ă��邩���m��Ȃ��̂ŁA���ׂ�B
		
		local value = exec.mov(sRet, Bareword(index)) -- NSExec("_mov $xxx,stralias")
		-- �����܂ŗ����ƌ������Ƃ́A���������`����Ă����ƌ������ƁB
		rawset(ob, index, value)
		return value
	end

	-- ���W���[���̍쐬
	stralias = setmetatable({}, mt)
end

--[[
	stralias���Ǘ����郂�W���[���B
	
	�V����stralias��ݒ肷�鎞�́A
	
	stralias.new_alias = "������"

	����́A

	stralias new_alias,"������"

	�Ɠ����B

	�ݒ肵��stralias���擾����ɂ́A
	
	stralias.new_alias �Ƃ���΂����B

	�����Ƃ��Astralias�Ƃ��������ł̂͒����̂ŁA�قƂ�ǂ̏ꍇ��alias���L�q����΂悢�B
]]
