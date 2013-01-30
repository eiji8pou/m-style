-- trace.lua
--[[
	���샍�O���o�́A�L�^���郂�W���[��
]]
do
	-- �_�~�[�̊֐���ݒ肷��B
	write_log = function() end

	-- �f�B�b�v�X�C�b�`�����āA�㏑������B
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
