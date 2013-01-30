-- m-style.lua

--[[
	�ގ��X�N���v�g�̃��C�u����
	���̃t�@�C������A�ގ��̊e���W���[����ǂݍ��ށB
]]

do
	-- �Q�[���͂܂���`���ł��B
	game_start = false

	-- �ގ����C�u�����̒u���ꏊ���`
	local dir = "m-style\\"

	-- �e�X�g�X�N���v�g�̒u����
	test_functions = {}
	function test_mode_run()
		for module, test_function in pairs(test_functions) do
			test_function()
		end
	end

	-- ��O��ɂȂ�Json.lua��ǂݍ��ށB
	NL_dofile(dir.."Json.lua")
	
	-- ���C�u������ǂݍ��ފ֐����`
	local ld = function(module)
		NL_dofile(dir..module..".lua")
	end

-- �ėp�̃��W���[���Q

	
	-- ���w���W���[��
	ld("math")
	
	-- �����񑀍�̃��W���[��
	ld("string")
	
	-- �e�[�u������̃��W���[��
	ld("table")

-- �J�����𐮂��郂�W���[���Q

	-- �f�B�b�v�X�C�b�`�̃��W���[��
	ld("dip")
	
	-- ���샍�O���L�^���郂�W���[��
	ld("trace")
	
	-- �G���[���b�Z�[�W�̃��W���[��
	ld("error")
	
	-- �֐���ϊ�����֐��Q������
	ld("convert")

	-- �����Ɋւ��郂�W���[��
	ld("random")

-- nslua�̊��ɉe�����郂�W���[���Q

	-- luacall�Ɋւ��郂�W���[��
	ld("luacall")
	
	-- luasub�Ɋւ��郂�W���[��
	ld("luasub")
	
	-- numalias��錾���郂�W���[��
	ld("numalias")

	-- stralias��錾���郂�W���[��
	ld("stralias")
	
	-- NScripter�̐��l�ϐ��ƕ�����ϐ����֐������郂�W���[��
	ld("variable")
	
	-- NScripter���̖��߂����s���郂�W���[��
	ld("exec")
	
	-- NScripter����DLL�����s���A���̌��ʂ��擾���郂�W���[��
	ld("dll")




















	-- �Q�[���͊J�n����܂��B���̃t���O�𗧂āA�L�^���܂��B
	game_start = true
	write_log("game_start")
end
