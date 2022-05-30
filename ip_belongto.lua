
local SCODE = {"BJ","SH","GD","JS","ZJ","CQ","AH","FJ","GS","GX","GZ","HI","HE","HL","HA","HB","HN","JX","JL","LN","NM","QH","SD","SX","SN","SC","TJ","YN","HK",}
local PROV  = {"北京","上海","广东","江苏","浙江","重庆","安徽","福建","甘肃","广西",
"贵州","海南","河北","黑龙江","河南","湖北","湖南","江西","吉林","辽宁","内蒙古",
"青海","山东","山西","陕西","四川","天津","云南","香港"}

local args = {...}
if #args < 2 then
    print("usage: lua ip_belongto.lua Province[Code] ip[file]")
    print("  Province[Code] 指定省份或省份代码")
    print("  ip[file] 指定单个ip或ip列表文件(每行1个ip)")
    print("  Province Code:")
    print("  从游戏日志中获取ip到ip.txt:")
    print("    ls run/*.gz | xargs gzip -df")
    print("    cat run/log |grep 'ip=' |grep device= | awk -F ' ' '{print $7}' |awk -F '=' '{print $2}' >> ip.txt")
    print("    或者批量:")
    print("    for f in run/log*; do cat $f |grep 'ip=' |grep device= | awk -F ' ' '{print $7}' |awk -F '=' '{print $2}' >> ip.txt; done")
    print("    cat ip.txt |sort|uniq -c|sort -k 1 -n -r |awk '{print $2}' > ip.1")
    for i, v in ipairs(SCODE) do
        print(string.format("  %s %s", PROV[i], v))
    end
    os.exit(1)
end

local function getCode(code)
    for _, v in ipairs(SCODE) do
        if code == v then
            return code, PROV[_]
        end
    end
    for i, v in ipairs(PROV) do
        if code == v then
            return SCODE[i], v
        end
    end
end

-- check Province Code
--
local code, prov = getCode(args[1])
if not code then
    print(string.format("Invalid Province[Code] %s", args[1]))
    os.exit(1)
end

-- download ip file
--
local function O_FILE(v)
    return string.format(".temp/__%s", v)
end
local f = io.open(O_FILE(code), "r")
if not f then
    local url = "curl -H 'Cache-Control: no-cache'"
    url = string.format("%s -o %s http://ips.chacuo.net/down/t_txt=p_%s", url, O_FILE(code), v)
    --print("fetch url:", url)
    os.execute("mkdir -pv .temp")
    local d = io.popen(url, "r")
    d:close()
    f = io.open(O_FILE(code), "r")
end

-- generate ip range
--
local function toIP(s)
    local b4, b3, b2, b1 = s:match("^(%d+)%.(%d+)%.(%d+)%.(%d+)$")
    b4, b3, b2, b1 = tonumber(b4), tonumber(b3), tonumber(b2), tonumber(b1)
    return b4<<24|b3<<16|b2<<8|b1
end

local ipRange = {}
for l in f:lines() do
    if l:byte(1) ~= 60 then -- '<'
        local ip1, ip2 = l:match("^(%g+)%s+(%g+)%s+(%d+)")
        if ip1 then
            ip1 = toIP(ip1)
            ip2 = toIP(ip2)
            table.insert(ipRange, {
                    ip1 = ip1,
                    ip2 = ip2,
                })
        end
    end
end
f:close()

-- check ip belong to
--
local function isIP(s)
    local b4, b3, b2, b1 = s:match("^(%d+)%.(%d+)%.(%d+)%.(%d+)$")
    b4, b3, b2, b1 = tonumber(b4), tonumber(b3), tonumber(b2), tonumber(b1)
    return b1 and b2 and b3 and b4
end
local function checkIP(s, R)
    local ip = toIP(s)
    for _, v in ipairs(ipRange) do
        if ip >= v.ip1 and ip <= v.ip2 then
            --print (string.format("[YES] ip=%s 属于 %s", s, prov))
            R[#R+1] = {ip=s, prov=prov}
            break
        end
    end
    print(string.format("[NO] ip=%s 不属于 %s", s, prov))
end
local R = {}
if isIP(args[2]) then
    checkIP(args[2], R)
else
    local n = 0
    local f = io.open(args[2], 'r')
    while true do
        local l = f:read('l')
        if not l then
            break
        end
        if checkIP(l, R) then
            n = n+1
        end
    end
end
for _, v in ipairs(R) do
    print (string.format("[YES] ip=%s 属于 %s", v.s, v.prov))
end
print(string.format("count=%d", #R))
