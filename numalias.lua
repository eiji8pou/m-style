-- numalias.lua
do
	-- メタテーブル＝クラス
	local mt = {}

	-- 新しい値が設定された時
	mt.__newindex = function(ob, index, value)
		-- 既に定義が終わっているなら、エラーになる。
		if game_start then
			die("既にgameが実行されています。numaliasを定義することはできません。", "numalias.lua")
		end
		-- 引数のチェック。
		arg.command(index, "numalias.lua")
		arg.int(value, "numalias.lua")
		-- numaliasの実行
		NSExec("_numalias "..index..","..tostring(value))
		-- numaliasの保管
		rawset(ob, index, value)
	end
	
	-- 値が呼び出された時
	mt.__index = function(ob, index)
		-- 引数のチェック。
		arg.command(index, "numalias.lua")
		-- ここに来たと言うことは、このモジュールの定義を行なっていないと言うこと。
		-- NScripter側で定義されているかも知れないので、調べる。
		
		local value = exec.mov(iRet, Bareword(index)) -- NSExec("_mov %xxx,numalias")
		-- ここまで来たと言うことは、しっかり定義されていたと言うこと。
		rawset(ob, index, value)
		return value
	end

	-- モジュールの作成
	numalias = setmetatable({}, mt)
end

--[[
	numaliasを管理するモジュール。
	
	新しいnumaliasを設定する時は、
	
	numalias.new_alias = 80

	これは、

	numalias new_alias,80

	と等価。

	設定したnumaliasを取得するには、
	
	numalias.new_alias とすればいい。

	もっとも、numalaisといちいち打つのは長いので、ほとんどの場合はaliasを記述すればよい。
]]
