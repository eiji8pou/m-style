-- numalias.lua
do
	-- ���^�e�[�u�����N���X
	local mt = {}

	-- �V�����l���ݒ肳�ꂽ��
	mt.__newindex = function(ob, index, value)
		-- ���ɒ�`���I����Ă���Ȃ�A�G���[�ɂȂ�B
		if game_start then
			die("����game�����s����Ă��܂��Bnumalias���`���邱�Ƃ͂ł��܂���B", "numalias.lua")
		end
		-- �����̃`�F�b�N�B
		arg.command(index, "numalias.lua")
		arg.int(value, "numalias.lua")
		-- numalias�̎��s
		NSExec("_numalias "..index..","..tostring(value))
		-- numalias�̕ۊ�
		rawset(ob, index, value)
	end
	
	-- �l���Ăяo���ꂽ��
	mt.__index = function(ob, index)
		-- �����̃`�F�b�N�B
		arg.command(index, "numalias.lua")
		-- �����ɗ����ƌ������Ƃ́A���̃��W���[���̒�`���s�Ȃ��Ă��Ȃ��ƌ������ƁB
		-- NScripter���Œ�`����Ă��邩���m��Ȃ��̂ŁA���ׂ�B
		
		local value = exec.mov(iRet, Bareword(index)) -- NSExec("_mov %xxx,numalias")
		-- �����܂ŗ����ƌ������Ƃ́A���������`����Ă����ƌ������ƁB
		rawset(ob, index, value)
		return value
	end

	-- ���W���[���̍쐬
	numalias = setmetatable({}, mt)
end

--[[
	numalias���Ǘ����郂�W���[���B
	
	�V����numalias��ݒ肷�鎞�́A
	
	numalias.new_alias = 80

	����́A

	numalias new_alias,80

	�Ɠ����B

	�ݒ肵��numalias���擾����ɂ́A
	
	numalias.new_alias �Ƃ���΂����B

	�����Ƃ��Anumalais�Ƃ��������ł̂͒����̂ŁA�قƂ�ǂ̏ꍇ��alias���L�q����΂悢�B
]]
