-- m-style.lua

--[[
	む式スクリプトのライブラリ
	このファイルから、む式の各モジュールを読み込む。
]]

do
	-- ゲームはまだ定義中です。
	game_start = false

	-- む式ライブラリの置き場所を定義
	local dir = "m-style\\"

	-- テストスクリプトの置き場
	test_functions = {}
	function test_mode_run()
		for module, test_function in pairs(test_functions) do
			test_function()
		end
	end

	-- 大前提になるJson.luaを読み込む。
	NL_dofile(dir.."Json.lua")
	
	-- ライブラリを読み込む関数を定義
	local ld = function(module)
		NL_dofile(dir..module..".lua")
	end

-- 汎用のモジュール群

	
	-- 数学モジュール
	ld("math")
	
	-- 文字列操作のモジュール
	ld("string")
	
	-- テーブル操作のモジュール
	ld("table")

-- 開発環境を整えるモジュール群

	-- ディップスイッチのモジュール
	ld("dip")
	
	-- 動作ログを記録するモジュール
	ld("trace")
	
	-- エラーメッセージのモジュール
	ld("error")
	
	-- 関数を変換する関数群を実装
	ld("convert")

	-- 乱数に関するモジュール
	ld("random")

-- nsluaの環境に影響するモジュール群

	-- luacallに関するモジュール
	ld("luacall")
	
	-- luasubに関するモジュール
	ld("luasub")
	
	-- numaliasを宣言するモジュール
	ld("numalias")

	-- straliasを宣言するモジュール
	ld("stralias")
	
	-- NScripterの数値変数と文字列変数を関数化するモジュール
	ld("variable")
	
	-- NScripter側の命令を実行するモジュール
	ld("exec")
	
	-- NScripter側のDLLを実行し、その結果を取得するモジュール
	ld("dll")




















	-- ゲームは開始されます。そのフラグを立て、記録します。
	game_start = true
	write_log("game_start")
end
