-- cd.lua
do
	-- nscr.exeが起動した時、それがハードディスク上にあるか、書き込めないCD上にあるかを判定するライブラリ
	-- 方法論としては大変簡単で、適当に書き込んでみて、成功すればHD上、そうでなければメディア上と判断する。

	-- 書き込みできるかどうか試すファイル名。
	local filename = "write_test.txt"
	-- 絶対にかぶらないファイル名に変更すること。

	local can_write = nil -- 書き込み可能かどうかのフラグ。
	
	local fh = io.open(filename, "w") -- 書き込みモードでファイルを開いてみる。
	if type(io.type(fh))=="nil" then -- 開けなかったら。
		can_write = false -- フラグをfalseに設定
	else -- 開けたら
		can_write = true -- フラグをtrueに設定
		fh:close() -- ファイルハンドルを閉じる。
		os.remove(filename) -- 削除する。
	end
	
	-- 外部に提供するメソッド群
	
	-- ハードディスク上にあるかどうか。
	function is_on_disk() return can_write end
	-- CD上にあるかどうか。
	function is_on_media() return not(is_on_disk()) end end
	
	-- また、同種の命令をNScripter側にも提供する。
	NSExec("_luasub is_on_disk")
	_G.NSCOM_is_on_disk = function() NSSetIntValue(NSPopIntRef(), is_on_disk() and 1 or 0) end
	NSExec("_luasub is_on_media")
	_G.NSCOM_is_on_media = function() NSSetIntValue(NSPopIntRef(), is_on_media() and 1 or 0) end
end
