-- table.lua
-- table���������C�u����
-- array���ǉ�����B
do
	array = {}

	-- �e�[�u���̃V���v���ȃR�s�[
	-- ���̂܂܃R�s�[����̂ŁA�l�Ƀe�[�u�����������肵���炻����Q�Ɠn�����Ă��܂��B
	table.copy = function(t)
		local new = {}
		for k, v in pairs(t) do new[k] = v end
		return new
	end
	array.copy = table.copy
	
	-- �e�[�u���̃N���[��
	-- �l��number, string, function���͂��̂܂ܑ���B
	-- table������΁A���������ɃN���[������B
	table.clone = function(t)
		local new = {}
		for k, v in pairs(t) do
			if type(v) == "table" then
				new[k] = table.clone(v)
			else
				new[k] = v
			end
		end
		return new
	end
	-- �z��̃N���[�������g�͓���
	array.clone = table.clone
	
	-- �e�[�u���̈ڂ��ւ�
	-- �e�[�u��from����e�[�u��to�ɒ��g��S������ւ���B
	-- �e�[�u���ϐ��̎��͕̂ύX�����ɁA���g�����ύX���������ɗL���B
	-- ���^�e�[�u���ɂ��Ă͂�����Ă��Ȃ��̂ŁA���ӁB
	-- to�͂�������ω����邪�Afrom�ɂ͉e���͂Ȃ��B
	table.move = function(from, to)
		for k, v in pairs(to)   do rawset(to, k, nil) end
		for k, v in pairs(from) do rawset(to, k, v  ) end
		return to
	end
	array.move = table.move

	-- �~�b�N�X�\�[�g�Ŏg����r�֐��Q
	local compare_box = {}
	compare_box.number = {}
	compare_box.number.number = function(a, b) return a<b end
	compare_box.number.string = function() return true end
	compare_box.string = {}
	compare_box.string.number = function() return false end
	compare_box.string.string = compare_box.number.number
	
	local compare = function(a, b)
		return compare_box[type(a)][type(b)](a, b)
	end
	
	-- �~�b�N�X�\�[�g�B���l�ƕ�����̓��荬�������z����\�[�g����B
	-- ���l�̌�ɕ����񂪂��āA���l�͐��l���m�A������͕����񓯎m���ԁB
	array.mix_sort = function(t) table.sort(t, compare) end
	
	-- ���̃e�[�u���̎����Ă���L�[���e�[�u���̒l�ɂ��ĕԂ��B
	table.keys = function(t)
		local new = {}
		for k, v in pairs(t) do new[1+#new] = k end
		table.sort(new, compare)
		return new
	end
	array.keys = table.keys
	
	-- ���̃e�[�u����number�^�L�[�̂����A�ő�l��Ԃ��B
	-- �Ԃ��΂����z��^�e�[�u���Ɏg���ƗL���B
	-- ������L�[���������Ă��Ă���������B
	table.last = function(t)
		local max = 0
		for k, v in pairs(t) do
			if type(k)=="number" then
				if max<k then max=k end
			end
		end
		return max
	end
	array.last = table.last
	
	-- �z��̋󂢂Ă镔�����w�肵�������Ŗ��߂�B
	array.fill = function(t, v)
		local max = array.last(t)
		if max==0 then return t end
		for i=1, max do
			if type(t[i])=="nil" then t[i] = v end
		end
		return t
	end
	
	-- �񕪖@
	-- �����Ɋ֐���^���A
	-- �z��^�e�[�u���̊e�v�f���̔z��^�e�[�u���ɕ����ĕԂ��B���Ԃ͎����B
	array.dichotomy = function(t, func)
		local res1 = {}
		local res2 = {}
		for i, v in ipairs(t) do
			if func(v) then res1[1+#res1] = v else res2[1+#res2] = v end
		end
		return res1, res2
	end
	
	-- �e�[�u���œ񕪖@
	-- ���Ԃ͎���Ȃ��B
	table.dichotomy = function(t, func)
		local res1 = {}
		local res2 = {}
		for i, v in pairs(t) do
			if func(v) then res1[i] = v else res2[i] = v end
		end
		return res1, res2
	end

	-- �t�B���^�����O
	array.filter = function(t, func)
		local res = array.dichotomy(t, func)
		return res
	end
	
	table.filter = function(t, func)
		local res = table.dichotomy(t, func)
		return res
	end

	-- ���j�[�N
	-- �z��ϐ��ɑ΂��Ďg���B�d������l����������A��x�ڈȍ~�͍폜���ăR�s�[��Ԃ��B
	array.unique = function(t)
		local check = {}
		local res = {}
		for i, v in ipairs(t) do
			if not(check[v]) then
				check[v] = true
				res[1+#res] = v
			end
		end
		return res
	end
	
	-- �����̔z���ڑ�����B
	-- �����ɂ͕����̔z���^����B�擪�̔z��ɁA�c��̑S�Ă̔z��̑S�v�f�𑫂��B
	-- ���̌�A�擪�̔z���Ԃ��B
	-- �擪�̔z�񂾂����e�����󂯁A���̔z��͉e�����󂯂Ȃ��B
	array.join = function(...)
		local args = {...}
		local res = table.remove(args, 1) -- �擪���擾
		for i, arg in ipairs(args) do
			if type(arg)=="table" then
				for k, v in ipairs(arg) do
					res[1+#res] = v
				end
			else
				res[1+#res] = arg
			end
		end
		return res
	end

	-- ���̔z��̒����烉���_���Ɉ�����o���ĕԂ��B
	-- table.remove���g���Ă���̂ŁA���������l�߂���B
	-- �������ɂ͊֐����w��ł���B�w��ł��Ȃ���΁Amath.random���g����B
	-- �������̊֐��́Amath.random�Ɉ�������w�肵���ꍇ�Ɠ��l�̓��삪���҂���Ă���B
	array.pick = function(t, func)
		if 0==#t then return nil end
		func = func or math.random
		return table.remove(t, func(#t))
	end
	
	-- ���̔z��̒����烉���_���Ɉ�����o���B
	-- ���������o�������Ȃ̂ŁA���̔z��ɉe���͂Ȃ��B
	array.choise = function(t, func)
		if 0==#t then return nil end
		func = func or math.random
		return t[func(#t)]
	end
	
	-- array.pick�̘A�z�z���
	-- �Ԃ�l��k, v�ɂȂ��Ă���_���Ⴄ�B
	table.pick = function(t, func)
		local k = array.pick(table.keys(t), func)
		local v = t[k]
		t[k] = nil
		return k, v
	end
end
