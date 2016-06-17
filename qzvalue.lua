local sfmt = string.format
local tbl = require 'tbl'
local args = {...}
local statkey = args[1] or "acc" -- acc按帐号统计，否则按角色统计
local time_live = args[2] or 0
local days = args[3] or 2
local start_day = args[4] or "2016-06-02"
print (time_live, days)

local user = "lxj"
local pass = "ABcd#adfa#*(#!*(*&Y*"

-- zone list
local conf = {
    { 
    gamedb_host="42.51.11.103",
    gamedb_user=user;
    gamedb_passwd=pass,
    gamedb_name="qzd0",
    gamedb_port=3306,

    logdb_host="42.51.11.103",
    logdb_user=user,
    logdb_passwd=pass,
    logdb_name="qzlog0",
    logdb_port=3306,
    },

    --{ 
    --gamedb_host="42.51.11.104",
    --gamedb_user=user,
    --gamedb_passwd=pass,
    --gamedb_name="qzd1",
    --gamedb_port=3306,

    --logdb_host="42.51.11.104",
    --logdb_user=user,
    --logdb_passwd=pass,
    --logdb_name="qzlog1",
    --logdb_port=3306,
    --},
}

-- get all zone all day login stat
local data = {}
for i, v in ipairs(conf) do
    local zone = {name=sfmt("%03d",i)}
    local h = io.popen(string.format(
        'cd ~/server/bin && ./shaco config_test --start "dumpdb_login" --time_live %d --days %d --start_day "%s" --gamedb_host "%s" --gamedb_user "%s" --gamedb_passwd "%s" --gamedb_port %s --gamedb_name "%s" --logdb_host "%s" --logdb_user "%s" --logdb_passwd "%s" --logdb_port "%s" --logdb_name "%s" --statkey %s',
        time_live, days, start_day,
        v.gamedb_host, v.gamedb_user, v.gamedb_passwd, v.gamedb_port, v.gamedb_name,
        v.logdb_host, v.logdb_user, v.logdb_passwd, v.logdb_port, v.logdb_name, 
        statkey))
    for l in h:lines() do
        print (l)
        if string.sub(l,1,6) == "=qzlog" then
            local one = {}
            one.name, one.total, one.pt_uc, one.pt_360 = string.match(l, 
            "=([^,]+),([^,]+),([^,]+),([^,]+)")
            one.total = one.total
            one.pt_uc = one.pt_uc
            one.pt_360 = one.pt_360
            zone[#zone+1] = one
        end
    end
    h:close()
    data[#data+1] = zone
end

-- calc zone sum
local zone_sum = {name="ALL"}
for i, day in ipairs(data[1]) do
    print (day.name)
    zone_sum[i] = {name=string.match(day.name, "([^%.]+)%.[^%.]+"), 
                total=0, pt_uc=0, pt_360=0}
end
for i=1, #zone_sum do
    for _, zone in ipairs(data) do
        zone_sum[i].total = zone_sum[i].total + zone[i].total
        zone_sum[i].pt_uc = zone_sum[i].pt_uc + zone[i].pt_uc
        zone_sum[i].pt_360= zone_sum[i].pt_360+ zone[i].pt_360
    end
end
local zone_add = {}
zone_add.name = "ADD"
zone_add.total = zone_sum[#zone_sum-1].total - zone_sum[#zone_sum].total
zone_add.pt_uc = zone_sum[#zone_sum-1].pt_uc - zone_sum[#zone_sum].pt_uc
zone_add.pt_360= zone_sum[#zone_sum-1].pt_360- zone_sum[#zone_sum].pt_360
zone_sum[#zone_sum+1] = zone_add
data[#data+1] = zone_sum

-- output
print(sfmt("%-45s | %10s | %10s | %10s", "DATETIME", "PLATFORM", "UC", "360"))
for i, zone in ipairs(data) do
    print (sfmt("[ZONE %s]", zone.name))
    for j, day in ipairs(zone) do
        print (sfmt("%-45s | %10d | %10d | %10d", day.name, day.total, day.pt_uc, day.pt_360))
    end
end
local L = zone_sum[#zone_sum-1]
local F = zone_sum[1]
print(sfmt("%-45s | %9.2f%% | %9.2f%% | %9.2f%%", "PERCENT",
L.total/F.total*100, 
L.pt_uc/F.pt_uc*100, 
L.pt_360/F.pt_360*100))
