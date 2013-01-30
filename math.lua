-- math.lua
--[[
	���w�֐����������郂�W���[��
]]

-- �f���֌W
do
	-- �f���̃����C�[�[�V����
	local prime_list = {2, 3}
	local prime_square_list = {4, 9}
	local last_prime = prime_list[#prime_list]
	
	-- �f�����X�g����L�΂�
	local prime_draw_single = function()
		-- �f���������B
		local test_number = last_prime -- �f����̍Ō�̔ԍ�
		while true do
			-- �f���ɂԂ���܂Ŏ����B
			test_number = test_number + 2
			if math.is_prime(test_number) then break end -- �f���Ȃ烋�[�v�𔲂���B
		end
		-- �f�����X�g�ɕt��������B
		prime_list[#prime_list+1] = test_number
		prime_square_list[#prime_list] = test_number * test_number
		last_prime = test_number
	end

	-- �f�����X�g��term�̒����ɂȂ�܂ŐL�΂��B
	local prime_draw = function(term)
		while type(prime_list[term]) == "nil" do prime_draw_single() end
	end

	-- �f�����ǂ������f����B
	math.is_prime = function(num)
		-- ���l�łȂ���΁A�f���ł͂Ȃ��B
		if type(num) ~= "number" then return false end
		-- 2���������Ȓl�ł���΁A�f���ł͂Ȃ��B
		if num < 2 then return false end
		-- �����łȂ���΁A�f���ł͂Ȃ��B
		if num ~= math.floor(num) then return false end
		-- 2�Ȃ�΁A�f���ł���B
		if num == 2 then return true end
		-- 2�̔{���Ȃ�Αf���ł͂Ȃ��B
		if num % 2 == 0 then return false end
		
		-- �����܂ł���΁A�f���̉\��������B
		
		-- ���̐��l�������̗�ɑ��݂��邩�ǂ������m�F����B
		if num == last_prime then return true end -- �f����̍Ō�̑f���ƈ�v����΁A�f���ł���B
		if num < last_prime then -- �����̑f���Ɋ��ɂ��肻���B
			for i = #prime_list, 1, -1 do
				if prime_list[i] == num then return true end -- ��v������̂�����΁A�f���ł���B
				if prime_list[i] < num then return false end -- ��v������̂��Ȃ������̂ŁA�f���ł͂Ȃ��B
			end
		end
		
		-- �f�����ǂ����́A���̒l�̕������܂ł̑f���Ŋ����Ă����āA��x������؂�Ȃ���Αf���ł���B
		local prime_counter = 2 -- �f����̔ԍ�
		local res = true
		while true do
			-- �f�����K�v�Ȃ����L��������B
			prime_draw(prime_counter)
			-- �������Ɠ����Ȃ�A�f���ł͂Ȃ��B�I���B
			if prime_square_list[prime_counter] == num then
				res = false
				break
			end
			-- �������ȏ�ɂȂ�����A���ʂɏI��B
			if prime_square_list[prime_counter] > num then break end
			
			-- �����܂ł���΁A�e�X�g���K�v�Ɗm��

			-- �e�X�g�Ɏg���f�����m��
			local touchstone = prime_list[prime_counter]
			-- �����ė]�肪�o�Ȃ�������A�f���ł͂Ȃ��B
			if num % touchstone == 0 then
				res = false
				break
			end
			
			-- ���[�v�m��B���̃e�X�g�f���������B
			prime_counter = prime_counter + 1
		end
		return res
	end

	-- ���l��f�����������āA�e�[�u���ɂ��ĕԂ��B
	-- �e�[�u���́At[1]��2�̏搔�At[2]��3�̏搔�At[3]��5�̏搔�c�c�ƂȂ��Ă���B
	math.prime_decomposition = function(num)
		-- ���l�łȂ����nil��Ԃ��B
		if type(num) ~= "number" then return nil end
		-- �����łȂ����nil��Ԃ��B
		if num ~= math.floor(num) then return nil end
		-- 1�ȏ�̐��l�łȂ����nil��Ԃ��B
		if num < 1 then return nil end
		
		-- 1�ł���΁A�񓚂͌��܂��Ă���B
		if num == 1 then return {0} end
		
		-- �����łȂ���΁A�v�Z����B
		local res = {} -- �Ԃ��e�[�u��
		local prime_counter = 1
		while true do
			prime_draw(prime_counter) -- �f�����X�g��L�΂��B
			res[prime_counter] = res[prime_counter] or 0 -- ������
			local prime = prime_list[prime_counter] -- �f�������
			if num % prime == 0 then -- ����؂ꂽ�Ȃ��
				num = num / prime
				res[prime_counter] = res[prime_counter] + 1
				if num == 1 then break end
			else
				prime_counter = prime_counter + 1
			end
		end
		return res
	end

	-- prime_decomposition�łł����e�[�u�������̐��l�ɖ߂��B
	math.prime_encomposition = function(t)
		-- �e�[�u���łȂ����nil��Ԃ��B
		if type(t) ~= "table" then return nil end
		
		-- �l�������Ă���
		local res = 1
		for prime_counter, multiplier in ipairs(t) do
			prime_draw(prime_counter) -- �f�����X�g�����L����B
			if multiplier > 0 then
				for i = 1, multiplier do
					res = res * prime_list[prime_counter]
				end
			end
		end
		return res
	end

	-- ���l�Ȃ�f���������A���ɂ��Ă���Ȃ炻�̂܂ܕԂ��B
	local decomposition_verify = function(num_or_t)
		if type(num_or_t) == "number" then num_or_t = math.prime_decomposition(num_or_t) end
		if type(num_or_t) == "table" then return num_or_t end
		return nil
	end

	-- �ŏ����{����Ԃ��B�I�v�V������true��^����ƁA�e�[�u���̌`�ŕԂ��B
	math.lcm = function(num_or_t1, num_or_t2, opt)
		-- �������Ƃ��f������������B
		local t1 = decomposition_verify(num_or_t1)
		local t2 = decomposition_verify(num_or_t2)
		local term = math.max(#t1, #t2)
		-- �Ԃ�����
		local res = {}
		for i=1, term do
			res[i] = convert(t1[i], "number") + convert(t2[i], "number")
		end

		if opt then
			return res
		else
			return math.prime_encomposition(res)
		end
	end
	
	-- �ő���񐔂�Ԃ��B�I�v�V������true��^����ƁA�e�[�u���̌`�ŕԂ��B
	math.gcd = function(num_or_t1, num_or_t2, opt)
		-- �������Ƃ��f������������B
		local t1 = decomposition_verify(num_or_t1)
		local t2 = decomposition_verify(num_or_t2)
		local term = math.min(#t1, #t2)
		
		-- �Ԃ�����
		local res = {0}
		for i=1, term do
			if t1[i] and t2[i] then
				res[i] = math.min(t1[i], t2[i])
			else
				res[i] = 0
			end
		end

		if opt then
			return res
		else
			return math.prime_encomposition(res)
		end
	end

	-- �f����Ԃ��B�����́A�f����̔ԍ��B1�ȏ�
	math.prime = function(term)
		prime_draw(term)
		return prime_list[term]
	end
end

