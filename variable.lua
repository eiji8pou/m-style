-- variable.lua
do
	-- 既存の関数を上書き
	-- ログをとれるようにする。
	local oNSSetIntValue = NSSetIntValue
	NSSetIntValue = function(num, val)
		val = convert(val, "number")
		write_log("write %"..num, val)
		oNSSetIntValue(num, val)
	end

	local oNSSetStrValue = NSSetStrValue
	NSSetStrValue = function(num, val)
		val = convert(val, "string")
		write_log("write $"..num, val)
		oNSSetStrValue(num, val)
	end

	local oNSGetIntValue = NSGetIntValue
	NSGetIntValue = function(num)
		local val = oNSGetIntValue(num)
		write_log("read %"..num, val)
		return val
	end

	local oNSGetStrValue = NSGetStrValue
	NSGetStrValue = function(num)
		local val = oNSGetStrValue(num)
		write_log("read $"..num, val)
		return val
	end
	
	-- 関数の本体
	local int_mt = {}
	int_mt.__call = function(this, val)
		local num = rawget(this, "num")
		if type(val) ~= "nil" then NSSetIntValue(num, val) end
		return NSGetIntValue(num)
	end
	int_mt.__newindex = function() end
	int_mt.__len = function(this) return rawget(this, "num") end

	local str_mt = {}
	str_mt.__call = function(this, val)
		local num = rawget(this, "num")
		if type(val) ~= "nil" then NSSetStrValue(num, val) end
		return NSGetStrValue(num)
	end
	str_mt.__newindex = function() end
	str_mt.__len = function(this) return rawget(this, "num") end

	-- 作った関数を保存する変数
	local int_list = {}
	local str_list = {}

	-- 関数を作る関数
	local make_int_var_func = function(num)
		int_list[num] = int_list[num] or setmetatable({num=num}, int_mt)
		return int_list[num]
	end

	local make_str_var_func = function(num)
		str_list[num] = str_list[num] or setmetatable({num=num}, str_mt)
		return str_list[num]
	end

	-- 他のモジュールから請われて変数関数を与える関数。
	local local_int_start = 100
	local local_str_start = 100
	local global_int_start = 1000
	local global_str_start = 1000

	function get_int(code)
		local num = local_int_start
		if type(code)=="string" then -- numaliasが指定されたとみなす。
			-- numaliasを作成する。
			num = numalias_verify(code, local_int_start)
			local_int_start = local_int_start + 1
		end
		if type(code)=="nil" then -- 自動採番
			num = local_int_start
			local_int_start = local_int_start + 1
		end
		if type(code)=="number" then
			num = code
		end
		-- 数値関数を返す。
		return make_int_var_func(num)
	end

	function get_str(code)
		local num = local_str_start
		if type(code)=="string" then -- numaliasが指定されたとみなす。
			-- numaliasを作成する。
			num = numalias_verify(code, local_str_start)
			local_str_start = local_str_start + 1
		end
		if type(code)=="nil" then -- 自動採番
			num = local_str_start
			local_str_start = local_str_start + 1
		end
		if type(code)=="number" then
			num = code
		end
		-- 数値関数を返す。
		return make_str_var_func(num)
	end


end
