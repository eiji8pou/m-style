-- random.lua
--[[
	線形合同法による乱数発生装置のモジュール
	線形合同法の公式
	
	X(n+1) = A*X(n)+B mod M
]]
do

	-- 線形合同法によるテーブルを返す。
	math.make_lcgs = function(a, b, m, seed)
		local t = {}
		-- 定数部分
		t.a = a
		t.b = b
		t.m = m
		
		-- 変動値
		seed = seed or 0
		t.seed = seed
		t.x = seed
		t.cycle = 0
		t.count = 0
		
		return t
	end

	-- 線形合同法に使うテーブルをランダムに作って返す。mを指定する。
	math.auto_make_lcgs = function(m)
		-- mを素因数分解する。
		local mt = math.prime_decomposition(m)

		-- bは、mと素因数が被らない数値で、かつM未満である。
		local b_candidate = {} -- bの素因数候補
		for i, v in ipairs(mt) do
			if v == 0 then
				-- mtの持ってない素因数は持つ。
				b_candidate[#b_candidate+1] = math.prime(i)
			end
		end
		local b = 1 -- 仮のb
		while true do
			local prime = array.choise(b_candidate)
			if b * prime < m then
				b = b * prime
			else
				break
			end
		end
		-- bが確定する。

		local a1 = 1 -- 仮のa
		for i, v in ipairs(mt) do
			-- mの素因数
			if v > 0 then
				a1 = a1 * math.prime(i)
			end
		end
		-- 4の倍数制限
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
		-- aが確定する。
		return math.make_lcgs(a, b, m)
	end

	-- テーブルを受けて、線形合同法として計算して次の値を返す。
	math.lcgs = function(t)
		-- カウントを増やす。
		t.count = t.count + 1
		
		-- 次の値を計算する。
		t.x = ( t.a * t.x + t.b ) % t.m
		
		-- 周回チェック
		if t.x == t.seed then
			-- 一周したので、周回カウンタを増やす。
			t.cycle = t.cycle + 1
		end
		return t.x
	end

	-- 線形合同法として正しい定数の関係を保っているか。
	math.is_legal_lcgs = function(t)
		-- M > A
		if not(t.m > t.a) then return false end
		-- M > B
		if not(t.m > t.b) then return false end
		-- A > 0
		if not(t.a > 0 ) then return false end
		-- B >= 0
		if t.b < 0 then return false end
		-- 全ての条件をクリアーしたので、
		return true
	end

	-- 線形合同法に照らして、最大周期を持つかどうかを返す。
	math.is_max_cycle_lcgs = function(t)
	
		-- 1.BとMが互いに素である。→共通の素因数を持たない。
		-- 2.A-1が、Mの持つ全ての素因数で割り切れる。→A-1とMの素因数の種類が一致する。
		-- 3.Mが4の倍数である場合は、A-1も4の倍数である。
		
		local at = math.prime_decomposition(t.a-1)
		local bt = math.prime_decomposition(t.b)
		local mt = math.prime_decomposition(t.m)
		
		-- 条件1
		if math.lcm(bt, mt) > 1 then return false end
		-- 条件2
		for i, v in ipairs(mt) do
			if v > 0 and at[i] > 0 then else return false end
		end
		-- 条件3
		if mt[1] > 1 then
			if at[1] < 2 then return false end
		end
		
		-- 全ての条件を満たしたので。
		return true
	end

	-- 線形合同法による乱数をサイコロに変える。
	math.lcgs2die = function(t, aspect) -- aspectはサイコロの面数
		-- サイコロ
		aspect = aspect or 6
		-- 乱数を取得
		local num = math.floor( math.lcgs(t) / 2 )-- 下位ビットを消すために2で割る。
		return num % aspect + 1
	end
end
