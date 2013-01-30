-- random.lua
--[[
	���`�����@�ɂ�闐���������u�̃��W���[��
	���`�����@�̌���
	
	X(n+1) = A*X(n)+B mod M
]]
do

	-- ���`�����@�ɂ��e�[�u����Ԃ��B
	math.make_lcgs = function(a, b, m, seed)
		local t = {}
		-- �萔����
		t.a = a
		t.b = b
		t.m = m
		
		-- �ϓ��l
		seed = seed or 0
		t.seed = seed
		t.x = seed
		t.cycle = 0
		t.count = 0
		
		return t
	end

	-- ���`�����@�Ɏg���e�[�u���������_���ɍ���ĕԂ��Bm���w�肷��B
	math.auto_make_lcgs = function(m)
		-- m��f������������B
		local mt = math.prime_decomposition(m)

		-- b�́Am�Ƒf���������Ȃ����l�ŁA����M�����ł���B
		local b_candidate = {} -- b�̑f�������
		for i, v in ipairs(mt) do
			if v == 0 then
				-- mt�̎����ĂȂ��f�����͎��B
				b_candidate[#b_candidate+1] = math.prime(i)
			end
		end
		local b = 1 -- ����b
		while true do
			local prime = array.choise(b_candidate)
			if b * prime < m then
				b = b * prime
			else
				break
			end
		end
		-- b���m�肷��B

		local a1 = 1 -- ����a
		for i, v in ipairs(mt) do
			-- m�̑f����
			if v > 0 then
				a1 = a1 * math.prime(i)
			end
		end
		-- 4�̔{������
		if mt[1] > 1 then a1 = a1 * 2 end
		
		while true do
			local prime = math.prime(math.random(#mt))
			if ( a1 * prime ) + 1 < m then
				a1 = a1 * prime
			else
				break
			end
		end
		local a = a1 + 1
		-- a���m�肷��B
		return math.make_lcgs(a, b, m)
	end

	-- �e�[�u�����󂯂āA���`�����@�Ƃ��Čv�Z���Ď��̒l��Ԃ��B
	math.lcgs = function(t)
		-- �J�E���g�𑝂₷�B
		t.count = t.count + 1
		
		-- ���̒l���v�Z����B
		t.x = ( t.a * t.x + t.b ) % t.m
		
		-- ����`�F�b�N
		if t.x == t.seed then
			-- ��������̂ŁA����J�E���^�𑝂₷�B
			t.cycle = t.cycle + 1
		end
		return t.x
	end

	-- ���`�����@�Ƃ��Đ������萔�̊֌W��ۂ��Ă��邩�B
	math.is_legal_lcgs = function(t)
		-- M > A
		if not(t.m > t.a) then return false end
		-- M > B
		if not(t.m > t.b) then return false end
		-- A > 0
		if not(t.a > 0 ) then return false end
		-- B >= 0
		if t.b < 0 then return false end
		-- �S�Ă̏������N���A�[�����̂ŁA
		return true
	end

	-- ���`�����@�ɏƂ炵�āA�ő�����������ǂ�����Ԃ��B
	math.is_max_cycle_lcgs = function(t)
	
		-- 1.B��M���݂��ɑf�ł���B�����ʂ̑f�����������Ȃ��B
		-- 2.A-1���AM�̎��S�Ă̑f�����Ŋ���؂��B��A-1��M�̑f�����̎�ނ���v����B
		-- 3.M��4�̔{���ł���ꍇ�́AA-1��4�̔{���ł���B
		
		local at = math.prime_decomposition(t.a-1)
		local bt = math.prime_decomposition(t.b)
		local mt = math.prime_decomposition(t.m)
		
		-- ����1
		if math.lcm(bt, mt) > 1 then return false end
		-- ����2
		for i, v in ipairs(mt) do
			if v > 0 and at[i] > 0 then else return false end
		end
		-- ����3
		if mt[1] > 1 then
			if at[1] < 2 then return false end
		end
		
		-- �S�Ă̏����𖞂������̂ŁB
		return true
	end

	-- ���`�����@�ɂ�闐�����T�C�R���ɕς���B
	math.lcgs2die = function(t, aspect) -- aspect�̓T�C�R���̖ʐ�
		-- �T�C�R��
		aspect = aspect or 6
		-- �������擾
		local num = math.floor( math.lcgs(t) / 2 )-- ���ʃr�b�g���������߂�2�Ŋ���B
		return num % aspect + 1
	end
end
