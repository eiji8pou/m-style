-- cd.lua
do
	-- nscr.exe���N���������A���ꂪ�n�[�h�f�B�X�N��ɂ��邩�A�������߂Ȃ�CD��ɂ��邩�𔻒肷�郉�C�u����
	-- ���@�_�Ƃ��Ă͑�ϊȒP�ŁA�K���ɏ�������ł݂āA���������HD��A�����łȂ���΃��f�B�A��Ɣ��f����B

	-- �������݂ł��邩�ǂ��������t�@�C�����B
	local filename = "write_test.txt"
	-- ��΂ɂ��Ԃ�Ȃ��t�@�C�����ɕύX���邱�ƁB

	local can_write = nil -- �������݉\���ǂ����̃t���O�B
	
	local fh = io.open(filename, "w") -- �������݃��[�h�Ńt�@�C�����J���Ă݂�B
	if type(io.type(fh))=="nil" then -- �J���Ȃ�������B
		can_write = false -- �t���O��false�ɐݒ�
	else -- �J������
		can_write = true -- �t���O��true�ɐݒ�
		fh:close() -- �t�@�C���n���h�������B
		os.remove(filename) -- �폜����B
	end
	
	-- �O���ɒ񋟂��郁�\�b�h�Q
	
	-- �n�[�h�f�B�X�N��ɂ��邩�ǂ����B
	function is_on_disk() return can_write end
	-- CD��ɂ��邩�ǂ����B
	function is_on_media() return not(is_on_disk()) end end
	
	-- �܂��A����̖��߂�NScripter���ɂ��񋟂���B
	NSExec("_luasub is_on_disk")
	_G.NSCOM_is_on_disk = function() NSSetIntValue(NSPopIntRef(), is_on_disk() and 1 or 0) end
	NSExec("_luasub is_on_media")
	_G.NSCOM_is_on_media = function() NSSetIntValue(NSPopIntRef(), is_on_media() and 1 or 0) end
end
