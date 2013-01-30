-- dip.lua
--[[
	ディップスイッチのモジュール
	一番最初にdip.txtを読み込み、その内容を保持する。
	他のモジュールはその内容を見て動作を変える。
	開発中のデバッグモードを期待している。
	
]]

do
	-- ディップスイッチを定義。
	dip = {}
	
	-- ディップスイッチのファイルを読み込む。
	local fh = io.open("dip.txt", "r")
	if io.type(fh) == "file" then
		for line in fh:lines() do
			local com = line
			-- コメントを削除する。
			com = com:gsub("%;.*$", "")
			-- 後方の空白文字を削除する。
			com = com:gsub("%s*$", "")
			-- 前方の空白文字を削除する。
			com = com:gsub("^%s*", "")
			-- もしまだ文字列が残っているのならば、それをディップスイットみなしてオンにする。
			if com:len()>0 then dip[com] = true end
		end
		fh:close()
	end

	-- テストスクリプト
	test_functions.dip = function()
		NSOkBox(
			Json.Encode(dip),
			"dipスイッチ"
		)
	end

end

--[[
	
]]
