local sfmt = string.format
local args = {...}
local start = 2
local last = assert(tonumber(args[1]))
local pre = "2016-06-"

print(sfmt("日期[%s ~ %s]", pre..start, pre..last))

local function stat(typ)
    for n=2, last-start+1 do
        print(sfmt("[%d]日留存", n))
        for i=2, last-n+1 do
            os.execute(sfmt("lua qzvalue.lua %s 0 %d %s ", 
            typ, n, pre..i))
        end
    end
end
print("帐号:")
stat('acc')
--print("")
--print("角色:")
--stat('role')

local function stat2(typ)
    for n=2, 2 do
        print(sfmt("[%d]日留存", n))
        for i=2, last-n+1 do
            os.execute(sfmt("lua qzvalue.lua %s 0 %d %s |tail -3", 
            typ, n, pre..i))
        end
    end
end
print("活跃与新增:")
--stat2('acc')
