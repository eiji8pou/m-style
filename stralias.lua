-- stralias.lua
do
	-- メタテーブル＝クラス
	local mt = {}

	-- 新しい値が設定された時
	mt.__newindex = function(ob, index, value)
		-- 既に定義が終わっているなら、エラーになる。
		if game_start then
			die("既にgameが実行されています。straliasを定義することはできません。", "stralias.lua")
		end
		-- 引数のチェック。
		arg.command(index, "stralias.lua")
		arg.string(value, "stralias.lua")
		-- straliasの実行
		exec.stralias(Bareword(index), value)
		-- straliasの保管
		rawset(ob, index, value)
	end
	
	-- 値が呼び出された時
	mt.__index = function(ob, index)
		-- 引数のチェック。
		arg.command(index, "stralias.lua")
		-- ここに来たと言うことは、このモジュールの定義を行なっていないと言うこと。
		-- NScripter側で定義されているかも知れないので、調べる。
		
		local value = exec.mov(sRet, Bareword(index)) -- NSExec("_mov $xxx,stralias")
		-- ここまで来たと言うことは、しっかり定義されていたと言うこと。
		rawset(ob, index, value)
		return value
	end

	-- モジュールの作成
	stralias = setmetatable({}, mt)
end

--[[
	straliasを管理するモジュール。
	
	新しいstraliasを設定する時は、
	
	stralias.new_alias = "文字列"

	これは、

	stralias new_alias,"文字列"

	と等価。

	設定したstraliasを取得するには、
	
	stralias.new_alias とすればいい。

	もっとも、straliasといちいち打つのは長いので、ほとんどの場合はaliasを記述すればよい。
]]
