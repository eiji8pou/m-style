-- trace.lua
--[[
	動作ログを出力、記録するモジュール
]]
do
	-- ダミーの関数を設定する。
	write_log = function() end

	-- ディップスイッチを見て、上書きする。
	if dip.trace then
		local log_file = "trace"..tostring(NSTimer())..".txt"
		local fh = io.open(log_file, "w")
		write_log = function(...)
			fh:write(tostring(NSTimer()))
			for i, v in ipairs({...}) do
				fh:write("\t")
				fh:write(convert(v, "string"))
			end
			fh:write("\n")
		end
	end
end
