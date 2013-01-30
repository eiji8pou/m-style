-- dll.lua
--[[
	lua������ANScripter����DLL�ďo�ƌ��ʎ擾���ȒP�ɂ���B
]]
do
	-- DLL�ďo�́Aexec_dll��getret�̑΂ɂȂ�̂���{
	
	-- �\�ߎ擾���Ă����B
	local exec_dll_func = exec.exec_dll
	local getret_func = exec.getret
	
	-- exec_dll
	-- ��������DLL��
	-- �������������̋�؂蕶��
	-- ��O�����ȍ~�͑S�Ĉ���
	function exec_dll(dll_name, separater, ...)
		local str = dll_name
		local arg = {...}
		if #arg > 0 then
			str = str .. "/" .. table.concat(arg, separater)
		end
		exec_dll_func(str)
		-- getret���܂Ƃ߂����́B���l�A������̏��ŕԂ��Ă���B
		return getret_func(iRet), getret_func(sRet)
	end

	-- exec_dll���֐��I�u�W�F�N�g�ɂ���֐�
	local dll_list = {} -- ������I�u�W�F�N�g��ۑ����鉽���B
	function make_exec(dll_name, separater)
		dll_list[dll_name] = dll_list[dll_name] or function(...)
			return exec_dll(dll_name, separater, ...)
		end
		return dll_list[dll_name]
	end
end
