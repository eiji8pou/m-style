-- dip.lua
--[[
	�f�B�b�v�X�C�b�`�̃��W���[��
	��ԍŏ���dip.txt��ǂݍ��݁A���̓��e��ێ�����B
	���̃��W���[���͂��̓��e�����ē����ς���B
	�J�����̃f�o�b�O���[�h�����҂��Ă���B
	
]]

do
	-- �f�B�b�v�X�C�b�`���`�B
	dip = {}
	
	-- �f�B�b�v�X�C�b�`�̃t�@�C����ǂݍ��ށB
	local fh = io.open("dip.txt", "r")
	if io.type(fh) == "file" then
		for line in fh:lines() do
			local com = line
			-- �R�����g���폜����B
			com = com:gsub("%;.*$", "")
			-- ����̋󔒕������폜����B
			com = com:gsub("%s*$", "")
			-- �O���̋󔒕������폜����B
			com = com:gsub("^%s*", "")
			-- �����܂������񂪎c���Ă���̂Ȃ�΁A������f�B�b�v�X�C�b�g�݂Ȃ��ăI���ɂ���B
			if com:len()>0 then dip[com] = true end
		end
		fh:close()
	end

	-- �e�X�g�X�N���v�g
	test_functions.dip = function()
		NSOkBox(
			Json.Encode(dip),
			"dip�X�C�b�`"
		)
	end

end

--[[
	
]]
