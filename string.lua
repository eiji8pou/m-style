-- string.lua
-- 文字列操作について、いささかの増強をする。
-- ただし、文字コードはShift-JIS限定
do
	-- 文字コードを入れると、
	-- それが半角文字であればtrueを、そうでなければfalseを返す。
	local code_decision = function(num)
		if num < 127 then return true  end
		if num < 161 then return false end
		if num < 224 then return true  end
		return false
	end

	-- 文字列の先頭の一文字を返す。
	string.initial = function(str)
		if str:len()==0 then return "" end
		if str:len()==1 then return str end
		if code_decision(str:byte()) then return str:sub(1, 1) end
		return str:sub(1, 2)
	end

	-- 文字列を文字単位に分解する。返り値はテーブル。
	string.separate_table = function(str)
		if str:len()==0 then return {} end -- 空文字列は何もしない。
		local res = {} -- 回答用
		local byte = {str:byte(1, str:len())} -- コードの配列にする。
		local code
		while 0 < #byte do
			code = table.remove(byte, 1) -- 一文字取ってくる。
			if code_decision(code) then -- 半角文字だった。
				res[1+#res] = string.char(code)
			else -- 全角文字だった。
				res[1+#res] = string.char(code, table.remove(byte, 1))
			end
		end
		return res
	end
	
	-- 文字列を文字単位に分解する。返り値はバラで。
	string.separate = function(str)
		return unpack(str:separate_table())
	end

	-- 文字列の先頭に指定された文字を追加していく。
	-- 引数は必要な桁数と、埋めるのに使う文字
	string.fill = function(str, digit, letter)
		-- digitは数値である必要がある。
		if type(digit)~="number" then return str end -- 数値でなければ何もしない。
		-- 後何文字必要かを計算する。
		local last = digit - str:len()
		if last < 1 then return str end -- 一文字未満であれば、何もしない。
 		-- letterは文字である必要がある。
 		if type(letter)~="string" then letter = " " end -- 文字にする。
 		if letter:len()==0 then letter = " " end -- 必ず一文字以上にする。
 		letter = letter:initial()
 
		local count = 0 -- repの実行回数。
		while last > 0 do
			last = last - letter:len()
			count = count + 1
		end
		return letter:rep(count)..str
	end
end
do
	-- 変換テーブル
	local han2zen_table = {
		[" "]="　",
		["!"]="！",
		["\""]="”",
		["#"]="＃",
		["$"]="＄",
		["%"]="％",
		["&"]="＆",
		["'"]="’",
		["("]="（",
		[")"]="）",
		["*"]="＊",
		["+"]="＋",
		[","]="，",
		["-"]="－",
		["."]="．",
		["/"]="／",
		["0"]="０",
		["1"]="１",
		["2"]="２",
		["3"]="３",
		["4"]="４",
		["5"]="５",
		["6"]="６",
		["7"]="７",
		["8"]="８",
		["9"]="９",
		[":"]="：",
		[";"]="；",
		["<"]="＜",
		["]="]="＝",
		[">"]="＞",
		["?"]="？",
		["@"]="＠",
		["A"]="Ａ",
		["B"]="Ｂ",
		["C"]="Ｃ",
		["D"]="Ｄ",
		["E"]="Ｅ",
		["F"]="Ｆ",
		["G"]="Ｇ",
		["H"]="Ｈ",
		["I"]="Ｉ",
		["J"]="Ｊ",
		["K"]="Ｋ",
		["L"]="Ｌ",
		["M"]="Ｍ",
		["N"]="Ｎ",
		["O"]="Ｏ",
		["P"]="Ｐ",
		["Q"]="Ｑ",
		["R"]="Ｒ",
		["S"]="Ｓ",
		["T"]="Ｔ",
		["U"]="Ｕ",
		["V"]="Ｖ",
		["W"]="Ｗ",
		["X"]="Ｘ",
		["Y"]="Ｙ",
		["Z"]="Ｚ",
		["["]="［",
		["\\"]="￥",
		["]"]="］",
		["^"]="＾",
		["_"]="＿",
		["`"]="‘",
		["a"]="ａ",
		["b"]="ｂ",
		["c"]="ｃ",
		["d"]="ｄ",
		["e"]="ｅ",
		["f"]="ｆ",
		["g"]="ｇ",
		["h"]="ｈ",
		["i"]="ｉ",
		["j"]="ｊ",
		["k"]="ｋ",
		["l"]="ｌ",
		["m"]="ｍ",
		["n"]="ｎ",
		["o"]="ｏ",
		["p"]="ｐ",
		["q"]="ｑ",
		["r"]="ｒ",
		["s"]="ｓ",
		["t"]="ｔ",
		["u"]="ｕ",
		["v"]="ｖ",
		["w"]="ｗ",
		["x"]="ｘ",
		["y"]="ｙ",
		["z"]="ｚ",
		["{"]="｛",
		["|"]="｜",
		["}"]="｝",
		["~"]="～",
		["｡"]="。",
		["｢"]="「",
		["｣"]="」",
		["､"]="、",
		["･"]="・",
		["ｦ"]="ヲ",
		["ｧ"]="ァ",
		["ｨ"]="ィ",
		["ｩ"]="ゥ",
		["ｪ"]="ェ",
		["ｫ"]="ォ",
		["ｬ"]="ャ",
		["ｭ"]="ュ",
		["ｮ"]="ョ",
		["ｯ"]="ッ",
		["ｰ"]="ー",
		["ｱ"]="ア",
		["ｲ"]="イ",
		["ｳ"]="ウ",
		["ｴ"]="エ",
		["ｵ"]="オ",
		["ｶ"]="カ",
		["ｷ"]="キ",
		["ｸ"]="ク",
		["ｹ"]="ケ",
		["ｺ"]="コ",
		["ｻ"]="サ",
		["ｼ"]="シ",
		["ｽ"]="ス",
		["ｾ"]="セ",
		["ｿ"]="ソ",
		["ﾀ"]="タ",
		["ﾁ"]="チ",
		["ﾂ"]="ツ",
		["ﾃ"]="テ",
		["ﾄ"]="ト",
		["ﾅ"]="ナ",
		["ﾆ"]="ニ",
		["ﾇ"]="ヌ",
		["ﾈ"]="ネ",
		["ﾉ"]="ノ",
		["ﾊ"]="ハ",
		["ﾋ"]="ヒ",
		["ﾌ"]="フ",
		["ﾍ"]="ヘ",
		["ﾎ"]="ホ",
		["ﾏ"]="マ",
		["ﾐ"]="ミ",
		["ﾑ"]="ム",
		["ﾒ"]="メ",
		["ﾓ"]="モ",
		["ﾔ"]="ヤ",
		["ﾕ"]="ユ",
		["ﾖ"]="ヨ",
		["ﾗ"]="ラ",
		["ﾘ"]="リ",
		["ﾙ"]="ル",
		["ﾚ"]="レ",
		["ﾛ"]="ロ",
		["ﾜ"]="ワ",
		["ﾝ"]="ン",
		["ﾞ"]="゛",
		["ﾟ"]="゜",
		["ｶﾞ"]="ガ",
		["ｷﾞ"]="ギ",
		["ｸﾞ"]="グ",
		["ｹﾞ"]="ゲ",
		["ｺﾞ"]="ゴ",
		["ｻﾞ"]="ザ",
		["ｼﾞ"]="ジ",
		["ｽﾞ"]="ズ",
		["ｾﾞ"]="ゼ",
		["ｿﾞ"]="ゾ",
		["ﾀﾞ"]="ダ",
		["ﾁﾞ"]="ヂ",
		["ﾂﾞ"]="ヅ",
		["ﾃﾞ"]="デ",
		["ﾄﾞ"]="ド",
		["ﾊﾞ"]="バ",
		["ﾊﾟ"]="パ",
		["ﾋﾞ"]="ビ",
		["ﾋﾟ"]="ピ",
		["ﾌﾞ"]="ブ",
		["ﾌﾟ"]="プ",
		["ﾍﾞ"]="ベ",
		["ﾍﾟ"]="ペ",
		["ﾎﾞ"]="ボ",
		["ﾎﾟ"]="ポ"
	}
	
	-- 半角文字に変換。テーブル化
	string.han2zen_table = function(str)
		if str:len()==0 then return {} end
		local t = str:separate_table() -- 文字毎に分割
		local res = {}
		local letter1 = nil
		local letter2 = nil
		while 0<#t do
			letter1 = table.remove(t, 1) -- 先頭の文字を取得
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
	
	-- 半角文字を全角文字に変換
	string.han2zen = function(str) return table.concat(str:han2zen_table()) end
	
	local zen2han_table = {}
	for k, v in pairs(han2zen_table) do
		zen2han_table[v] = k
	end
	
	-- 全角文字を半角に変換
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

	-- 全角を半角に変換
	string.zen2han = function(str) return table.concat(str:zen2han_table()) end
	
	-- 数値の構成要素として許可できる文字
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

	-- 全角混じり文字列を数値に変換
	string.tonumber = function(str)
		local t = str:zen2han_table()
		local res = {}
		for i, v in ipairs(t) do if digit_list[v] then res[1+#res] = v end end
		return tonumber(table.concat(res))
	end

	-- 文字列を単純に特定の文字で区切る。返り値はテーブル
	-- csvのパースには使えませんよ？
	-- 区切り文字は一文字である必要がある。そうでなければ、先頭の一文字が使われる。
	string.split_table_infinity = function(str, separater)
		if str:len()==0 then return {""} end -- ショートカット
		local t = str:separate_table() -- まずは文字単位に分割
		if separater:len()==0 then return t end
		local res = {""} -- 回答用テーブル
		local letter = nil -- 一時変数
		while 0<#t do -- tが存在し続ける限り回す。
			letter = table.remove(t, 1) -- tの最初の一つを取得
			if letter == separater then
				res[1+#res] = "" -- 文字列を追加
			else
				res[#res] = res[#res]..letter -- 最後の文字列に追加
			end
		end
		return res
	end
	
	string.split_table = function(str, separater, max)
		-- セパレータのデフォルト設定
		if type(separater)~="string" then separater="" end
		separater = separater:initial() -- 先頭だけが有効。
		local t = str:split_table_infinity(separater) -- とりあえず、無制限分割
		if type(max)~="number" then return t end -- maxがなければ終了
		if max<1 then return t end -- maxが1未満なら、分割制限なし扱い。終了。
		max = math.floor(max) -- 念のため、端数切捨て。
		if max==1 then return str end -- maxが1なら、分割しないの意味。
		-- それ以外なら、分割制限をする。
		local letter = nil
		while max<#t do
			letter = table.remove(t) -- 最後を削る。
			t[#t] = t[#t]..separater..letter -- 新しい最後に加える。
		end
		return t
	end
	
	-- 文字列を単純に特定の文字で区切る。返り値はバラで。
	string.split = function(str, separater, max)
		return unpack(str:split_table(separater, max))
	end

	-- メタ文字用の変換テーブルの作成
	local chara_code = {}
	for i=0, 255 do chara_code[i] = string.char(i) end
	local temp = "^$()%.[]*+-?"
	for i, v in ipairs({temp:byte(1, temp:len())}) do
		chara_code[v] = "%"..string.char(v)
	end

	-- メタ文字を殺して安全に変換する。
	string.kill_meta_chara = function(str)
		local ret = ""
		for i, v in ipairs({str:byte(1, str:len())}) do
			ret = ret .. chara_code[v]
		end
		return ret
	end
end
