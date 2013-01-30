--convert.lua
--[[
	型の違うものを適当に無理やり変換する関数を提供する。
]]

do

	-- 個々の変換に使う関数を格納する。
	local lib = {}

	-- 汎用的に使う物
	local return_nil   = function() return nil end
	local return_true  = function() return true end
	local return_false = function() return false end
	local boomerang = function(ob) return ob end
	local recursion = function(ob, target)
		local ret = ob()
		return lib[target][type(ret)](ret)
	end
	local return_zero = function() return 0 end
	local return_pack = function(ob) return function() return ob end end
	
	-- targetがnilの場合。何かをnilに変換する。
	lib["nil"] = {}
	lib["nil"]["nil"]      = return_nil
	lib["nil"]["boolean"]  = return_nil
	lib["nil"]["number"]   = return_nil
	lib["nil"]["string"]   = return_nil
	lib["nil"]["table"]    = return_nil
	lib["nil"]["function"] = return_nil
	lib["nil"]["thread"]   = return_nil
	lib["nil"]["userdata"] = return_nil
	-- 何を入れてもnilになる。w
	
	-- targetがbooleanの場合。何かをbooleanに変換する。
	lib["boolean"] = {}
	lib["boolean"]["nil"]      = return_false
	lib["boolean"]["boolean"]  = boomerang
	lib["boolean"]["number"]   = function(ob) return ob==0       and false or true end
	lib["boolean"]["string"]   = function(ob) return ob:len()==0 and false or true end
	lib["boolean"]["table"]    = function(ob) return #ob==0      and false or true end
	lib["boolean"]["function"] = function(ob) return recursion(ob, "boolean") end
	lib["boolean"]["thread"]   = return_true
	lib["boolean"]["userdata"] = return_true
	
	-- targetがnumberの場合。何かをnumberに変換する。
	lib["number"] = {}
	lib["number"]["nil"]       = return_zero
	lib["number"]["boolean"]   = function(ob) return ob and 1 or 0 end
	lib["number"]["number"]    = boomerang
	lib["number"]["string"]    = tostring
	lib["number"]["table"]     = function(ob) return #ob end
	lib["number"]["function"]  = function(ob) return recursion(ob, "number") end
	lib["number"]["thread"]    = return_zero
	lib["number"]["userdata"]  = return_zero
	
	-- targetがstringの場合。何かをstringに変換する。
	lib["string"] = {}
	lib["string"]["nil"]      = function() return "nil" end
	lib["string"]["boolean"]  = function(ob) return ob and "true" or "false" end
	lib["string"]["number"]   = tonumber
	lib["string"]["string"]   = boomerang
	lib["string"]["table"]    = Json.Encode
	lib["string"]["function"] = function(ob) return recursion(ob, "function") end
	lib["string"]["thread"]   = function() return "thread" end
	lib["string"]["userdata"] = function() return "userdata" end
	
	-- targetがfunctionの場合。それを返すfunctionに変換する。
	lib["function"] = {}
	lib["function"]["nil"]      = return_pack
	lib["function"]["boolean"]  = return_pack
	lib["function"]["number"]   = return_pack
	lib["function"]["string"]   = return_pack
	lib["function"]["function"] = boomerang
	lib["function"]["function"] = return_pack
	lib["function"]["thread"]   = return_pack
	lib["function"]["userdata"] = return_pack
	
	-- 汎用の変換関数
	convert = function(ob, target)
		-- obは変換元。
		-- targetは変換先の型。number, string, boolean, function
		target = target or "nil" -- targetを指定しないとnilにしちゃうよ。
		local sub_lib = lib[target]
		if sub_lib then
			return sub_lib[type(ob)](ob)
		else
			die("変換先の型が不明です。", "convert")
		end
	end

	-- 変換関数のショートカットを作る。
	-- 例えば、booleanをnumberに変換する場合は、bool2num関数を使う。
	-- 同様に、型名の略称は下記のとおり。

	-- 型名の略称
	local elp = {}
	elp["nil"]      = "nil"
	elp["boolean"]  = "bool"
	elp["number"]   = "num"
	elp["string"]   = "str"
	elp["table"]    = "t"
	elp["function"] = "func"
	elp["thread"]   = "thread"
	elp["userdata"] = "userdata"

	for target, func_list in pairs(lib) do
		for from, func in pairs(func_list) do
			-- 作られる関数名
			local func_name = elp[from].."2"..elp[target]
			-- 関数を定義
			_G[func_name] = function(ob)
				if type(ob) ~= from then error("変換元の型が不正です。", func_name) end
				return convert(ob, target)
			end
		end
	end
end
