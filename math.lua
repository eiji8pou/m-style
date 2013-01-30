-- math.lua
--[[
	数学関数を強化するモジュール
]]

-- 素数関係
do
	-- 素数のメモイゼーション
	local prime_list = {2, 3}
	local prime_square_list = {4, 9}
	local last_prime = prime_list[#prime_list]
	
	-- 素数リストを一つ伸ばす
	local prime_draw_single = function()
		-- 素数候補を作る。
		local test_number = last_prime -- 素数列の最後の番号
		while true do
			-- 素数にぶつかるまで試す。
			test_number = test_number + 2
			if math.is_prime(test_number) then break end -- 素数ならループを抜ける。
		end
		-- 素数リストに付け加える。
		prime_list[#prime_list+1] = test_number
		prime_square_list[#prime_list] = test_number * test_number
		last_prime = test_number
	end

	-- 素数リストがtermの長さになるまで伸ばす。
	local prime_draw = function(term)
		while type(prime_list[term]) == "nil" do prime_draw_single() end
	end

	-- 素数かどうか判断する。
	math.is_prime = function(num)
		-- 数値でなければ、素数ではない。
		if type(num) ~= "number" then return false end
		-- 2よりも小さな値であれば、素数ではない。
		if num < 2 then return false end
		-- 整数でなければ、素数ではない。
		if num ~= math.floor(num) then return false end
		-- 2ならば、素数である。
		if num == 2 then return true end
		-- 2の倍数ならば素数ではない。
		if num % 2 == 0 then return false end
		
		-- ここまでくれば、素数の可能性がある。
		
		-- その数値が既存の列に存在するかどうかを確認する。
		if num == last_prime then return true end -- 素数列の最後の素数と一致すれば、素数である。
		if num < last_prime then -- 既存の素数に既にありそう。
			for i = #prime_list, 1, -1 do
				if prime_list[i] == num then return true end -- 一致するものがあれば、素数である。
				if prime_list[i] < num then return false end -- 一致するものがなかったので、素数ではない。
			end
		end
		
		-- 素数かどうかは、その値の平方根までの素数で割っていって、一度も割り切れなければ素数である。
		local prime_counter = 2 -- 素数列の番号
		local res = true
		while true do
			-- 素数列を必要なだけ伸長させる。
			prime_draw(prime_counter)
			-- 平方根と同じなら、素数ではない。終了。
			if prime_square_list[prime_counter] == num then
				res = false
				break
			end
			-- 平方根以上になったら、普通に終る。
			if prime_square_list[prime_counter] > num then break end
			
			-- ここまでくれば、テストが必要と確定

			-- テストに使う素数を確定
			local touchstone = prime_list[prime_counter]
			-- 割って余りが出なかったら、素数ではない。
			if num % touchstone == 0 then
				res = false
				break
			end
			
			-- ループ確定。次のテスト素数を試す。
			prime_counter = prime_counter + 1
		end
		return res
	end

	-- 数値を素因数分解して、テーブルにして返す。
	-- テーブルは、t[1]が2の乗数、t[2]が3の乗数、t[3]が5の乗数……となっている。
	math.prime_decomposition = function(num)
		-- 数値でなければnilを返す。
		if type(num) ~= "number" then return nil end
		-- 整数でなければnilを返す。
		if num ~= math.floor(num) then return nil end
		-- 1以上の数値でなければnilを返す。
		if num < 1 then return nil end
		
		-- 1であれば、回答は決まっている。
		if num == 1 then return {0} end
		
		-- そうでなければ、計算する。
		local res = {} -- 返すテーブル
		local prime_counter = 1
		while true do
			prime_draw(prime_counter) -- 素数リストを伸ばす。
			res[prime_counter] = res[prime_counter] or 0 -- 初期化
			local prime = prime_list[prime_counter] -- 素数を特定
			if num % prime == 0 then -- 割り切れたならば
				num = num / prime
				res[prime_counter] = res[prime_counter] + 1
				if num == 1 then break end
			else
				prime_counter = prime_counter + 1
			end
		end
		return res
	end

	-- prime_decompositionでできたテーブルを元の数値に戻す。
	math.prime_encomposition = function(t)
		-- テーブルでなければnilを返す。
		if type(t) ~= "table" then return nil end
		
		-- 値をかけていく
		local res = 1
		for prime_counter, multiplier in ipairs(t) do
			prime_draw(prime_counter) -- 素数リストを延伸する。
			if multiplier > 0 then
				for i = 1, multiplier do
					res = res * prime_list[prime_counter]
				end
			end
		end
		return res
	end

	-- 数値なら素因数分解、既にしてあるならそのまま返す。
	local decomposition_verify = function(num_or_t)
		if type(num_or_t) == "number" then num_or_t = math.prime_decomposition(num_or_t) end
		if type(num_or_t) == "table" then return num_or_t end
		return nil
	end

	-- 最小公倍数を返す。オプションにtrueを与えると、テーブルの形で返す。
	math.lcm = function(num_or_t1, num_or_t2, opt)
		-- 引数を二つとも素因数分解する。
		local t1 = decomposition_verify(num_or_t1)
		local t2 = decomposition_verify(num_or_t2)
		local term = math.max(#t1, #t2)
		-- 返すもの
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
	
	-- 最大公約数を返す。オプションにtrueを与えると、テーブルの形で返す。
	math.gcd = function(num_or_t1, num_or_t2, opt)
		-- 引数を二つとも素因数分解する。
		local t1 = decomposition_verify(num_or_t1)
		local t2 = decomposition_verify(num_or_t2)
		local term = math.min(#t1, #t2)
		
		-- 返すもの
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

	-- 素数を返す。引数は、素数列の番号。1以上
	math.prime = function(term)
		prime_draw(term)
		return prime_list[term]
	end
end

