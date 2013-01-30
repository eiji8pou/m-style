-- string.lua
-- �����񑀍�ɂ��āA���������̑���������B
-- �������A�����R�[�h��Shift-JIS����
do
	-- �����R�[�h������ƁA
	-- ���ꂪ���p�����ł����true���A�����łȂ����false��Ԃ��B
	local code_decision = function(num)
		if num < 127 then return true  end
		if num < 161 then return false end
		if num < 224 then return true  end
		return false
	end

	-- ������̐擪�̈ꕶ����Ԃ��B
	string.initial = function(str)
		if str:len()==0 then return "" end
		if str:len()==1 then return str end
		if code_decision(str:byte()) then return str:sub(1, 1) end
		return str:sub(1, 2)
	end

	-- ������𕶎��P�ʂɕ�������B�Ԃ�l�̓e�[�u���B
	string.separate_table = function(str)
		if str:len()==0 then return {} end -- �󕶎���͉������Ȃ��B
		local res = {} -- �񓚗p
		local byte = {str:byte(1, str:len())} -- �R�[�h�̔z��ɂ���B
		local code
		while 0 < #byte do
			code = table.remove(byte, 1) -- �ꕶ������Ă���B
			if code_decision(code) then -- ���p�����������B
				res[1+#res] = string.char(code)
			else -- �S�p�����������B
				res[1+#res] = string.char(code, table.remove(byte, 1))
			end
		end
		return res
	end
	
	-- ������𕶎��P�ʂɕ�������B�Ԃ�l�̓o���ŁB
	string.separate = function(str)
		return unpack(str:separate_table())
	end

	-- ������̐擪�Ɏw�肳�ꂽ������ǉ����Ă����B
	-- �����͕K�v�Ȍ����ƁA���߂�̂Ɏg������
	string.fill = function(str, digit, letter)
		-- digit�͐��l�ł���K�v������B
		if type(digit)~="number" then return str end -- ���l�łȂ���Ή������Ȃ��B
		-- �㉽�����K�v�����v�Z����B
		local last = digit - str:len()
		if last < 1 then return str end -- �ꕶ�������ł���΁A�������Ȃ��B
 		-- letter�͕����ł���K�v������B
 		if type(letter)~="string" then letter = " " end -- �����ɂ���B
 		if letter:len()==0 then letter = " " end -- �K���ꕶ���ȏ�ɂ���B
 		letter = letter:initial()
 
		local count = 0 -- rep�̎��s�񐔁B
		while last > 0 do
			last = last - letter:len()
			count = count + 1
		end
		return letter:rep(count)..str
	end
end
do
	-- �ϊ��e�[�u��
	local han2zen_table = {
		[" "]="�@",
		["!"]="�I",
		["\""]="�h",
		["#"]="��",
		["$"]="��",
		["%"]="��",
		["&"]="��",
		["'"]="�f",
		["("]="�i",
		[")"]="�j",
		["*"]="��",
		["+"]="�{",
		[","]="�C",
		["-"]="�|",
		["."]="�D",
		["/"]="�^",
		["0"]="�O",
		["1"]="�P",
		["2"]="�Q",
		["3"]="�R",
		["4"]="�S",
		["5"]="�T",
		["6"]="�U",
		["7"]="�V",
		["8"]="�W",
		["9"]="�X",
		[":"]="�F",
		[";"]="�G",
		["<"]="��",
		["]="]="��",
		[">"]="��",
		["?"]="�H",
		["@"]="��",
		["A"]="�`",
		["B"]="�a",
		["C"]="�b",
		["D"]="�c",
		["E"]="�d",
		["F"]="�e",
		["G"]="�f",
		["H"]="�g",
		["I"]="�h",
		["J"]="�i",
		["K"]="�j",
		["L"]="�k",
		["M"]="�l",
		["N"]="�m",
		["O"]="�n",
		["P"]="�o",
		["Q"]="�p",
		["R"]="�q",
		["S"]="�r",
		["T"]="�s",
		["U"]="�t",
		["V"]="�u",
		["W"]="�v",
		["X"]="�w",
		["Y"]="�x",
		["Z"]="�y",
		["["]="�m",
		["\\"]="��",
		["]"]="�n",
		["^"]="�O",
		["_"]="�Q",
		["`"]="�e",
		["a"]="��",
		["b"]="��",
		["c"]="��",
		["d"]="��",
		["e"]="��",
		["f"]="��",
		["g"]="��",
		["h"]="��",
		["i"]="��",
		["j"]="��",
		["k"]="��",
		["l"]="��",
		["m"]="��",
		["n"]="��",
		["o"]="��",
		["p"]="��",
		["q"]="��",
		["r"]="��",
		["s"]="��",
		["t"]="��",
		["u"]="��",
		["v"]="��",
		["w"]="��",
		["x"]="��",
		["y"]="��",
		["z"]="��",
		["{"]="�o",
		["|"]="�b",
		["}"]="�p",
		["~"]="�`",
		["�"]="�B",
		["�"]="�u",
		["�"]="�v",
		["�"]="�A",
		["�"]="�E",
		["�"]="��",
		["�"]="�@",
		["�"]="�B",
		["�"]="�D",
		["�"]="�F",
		["�"]="�H",
		["�"]="��",
		["�"]="��",
		["�"]="��",
		["�"]="�b",
		["�"]="�[",
		["�"]="�A",
		["�"]="�C",
		["�"]="�E",
		["�"]="�G",
		["�"]="�I",
		["�"]="�J",
		["�"]="�L",
		["�"]="�N",
		["�"]="�P",
		["�"]="�R",
		["�"]="�T",
		["�"]="�V",
		["�"]="�X",
		["�"]="�Z",
		["�"]="�\",
		["�"]="�^",
		["�"]="�`",
		["�"]="�c",
		["�"]="�e",
		["�"]="�g",
		["�"]="�i",
		["�"]="�j",
		["�"]="�k",
		["�"]="�l",
		["�"]="�m",
		["�"]="�n",
		["�"]="�q",
		["�"]="�t",
		["�"]="�w",
		["�"]="�z",
		["�"]="�}",
		["�"]="�~",
		["�"]="��",
		["�"]="��",
		["�"]="��",
		["�"]="��",
		["�"]="��",
		["�"]="��",
		["�"]="��",
		["�"]="��",
		["�"]="��",
		["�"]="��",
		["�"]="��",
		["�"]="��",
		["�"]="��",
		["�"]="�J",
		["�"]="�K",
		["��"]="�K",
		["��"]="�M",
		["��"]="�O",
		["��"]="�Q",
		["��"]="�S",
		["��"]="�U",
		["��"]="�W",
		["��"]="�Y",
		["��"]="�[",
		["��"]="�]",
		["��"]="�_",
		["��"]="�a",
		["��"]="�d",
		["��"]="�f",
		["��"]="�h",
		["��"]="�o",
		["��"]="�p",
		["��"]="�r",
		["��"]="�s",
		["��"]="�u",
		["��"]="�v",
		["��"]="�x",
		["��"]="�y",
		["��"]="�{",
		["��"]="�|"
	}
	
	-- ���p�����ɕϊ��B�e�[�u����
	string.han2zen_table = function(str)
		if str:len()==0 then return {} end
		local t = str:separate_table() -- �������ɕ���
		local res = {}
		local letter1 = nil
		local letter2 = nil
		while 0<#t do
			letter1 = table.remove(t, 1) -- �擪�̕������擾
			if 0<#t then letter2 = letter1..t[1] else letter2 = "" end
			if han2zen_table[letter2] then
				res[1+#res] = han2zen_table[letter2]
				table.remove(t, 1)
			elseif han2zen_table[letter1] then
				res[1+#res] = han2zen_table[letter1]
			else
				res[1+#res] = letter1
			end
		end
		return res
	end
	
	-- ���p������S�p�����ɕϊ�
	string.han2zen = function(str) return table.concat(str:han2zen_table()) end
	
	local zen2han_table = {}
	for k, v in pairs(han2zen_table) do
		zen2han_table[v] = k
	end
	
	-- �S�p�����𔼊p�ɕϊ�
	string.zen2han_table = function(str)
		local t = str:separate_table()
		local res = {}
		local letter
		while 0<#t do
			letter = table.remove(t, 1)
			res[1+#res] = zen2han_table[letter] or letter
		end
		return res
	end

	-- �S�p�𔼊p�ɕϊ�
	string.zen2han = function(str) return table.concat(str:zen2han_table()) end
	
	-- ���l�̍\���v�f�Ƃ��ċ��ł��镶��
	local digit_list = {
		["0"] = true,
		["1"] = true,
		["2"] = true,
		["3"] = true,
		["4"] = true,
		["5"] = true,
		["6"] = true,
		["7"] = true,
		["8"] = true,
		["9"] = true,
		["."] = true,
		["-"] = true
	}

	-- �S�p�����蕶����𐔒l�ɕϊ�
	string.tonumber = function(str)
		local t = str:zen2han_table()
		local res = {}
		for i, v in ipairs(t) do if digit_list[v] then res[1+#res] = v end end
		return tonumber(table.concat(res))
	end

	-- �������P���ɓ���̕����ŋ�؂�B�Ԃ�l�̓e�[�u��
	-- csv�̃p�[�X�ɂ͎g���܂����H
	-- ��؂蕶���͈ꕶ���ł���K�v������B�����łȂ���΁A�擪�̈ꕶ�����g����B
	string.split_table_infinity = function(str, separater)
		if str:len()==0 then return {""} end -- �V���[�g�J�b�g
		local t = str:separate_table() -- �܂��͕����P�ʂɕ���
		if separater:len()==0 then return t end
		local res = {""} -- �񓚗p�e�[�u��
		local letter = nil -- �ꎞ�ϐ�
		while 0<#t do -- t�����݂����������񂷁B
			letter = table.remove(t, 1) -- t�̍ŏ��̈���擾
			if letter == separater then
				res[1+#res] = "" -- �������ǉ�
			else
				res[#res] = res[#res]..letter -- �Ō�̕�����ɒǉ�
			end
		end
		return res
	end
	
	string.split_table = function(str, separater, max)
		-- �Z�p���[�^�̃f�t�H���g�ݒ�
		if type(separater)~="string" then separater="" end
		separater = separater:initial() -- �擪�������L���B
		local t = str:split_table_infinity(separater) -- �Ƃ肠�����A����������
		if type(max)~="number" then return t end -- max���Ȃ���ΏI��
		if max<1 then return t end -- max��1�����Ȃ�A���������Ȃ������B�I���B
		max = math.floor(max) -- �O�̂��߁A�[���؎̂āB
		if max==1 then return str end -- max��1�Ȃ�A�������Ȃ��̈Ӗ��B
		-- ����ȊO�Ȃ�A��������������B
		local letter = nil
		while max<#t do
			letter = table.remove(t) -- �Ō�����B
			t[#t] = t[#t]..separater..letter -- �V�����Ō�ɉ�����B
		end
		return t
	end
	
	-- �������P���ɓ���̕����ŋ�؂�B�Ԃ�l�̓o���ŁB
	string.split = function(str, separater, max)
		return unpack(str:split_table(separater, max))
	end

	-- ���^�����p�̕ϊ��e�[�u���̍쐬
	local chara_code = {}
	for i=0, 255 do chara_code[i] = string.char(i) end
	local temp = "^$()%.[]*+-?"
	for i, v in ipairs({temp:byte(1, temp:len())}) do
		chara_code[v] = "%"..string.char(v)
	end

	-- ���^�������E���Ĉ��S�ɕϊ�����B
	string.kill_meta_chara = function(str)
		local ret = ""
		for i, v in ipairs({str:byte(1, str:len())}) do
			ret = ret .. chara_code[v]
		end
		return ret
	end
end
