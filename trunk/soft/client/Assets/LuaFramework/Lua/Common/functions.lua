
--输出日志--
function log(str)
    Util.Log(str);
end

--错误日志--
function logError(str) 
    Util.LogError(str);
end

--警告日志--
function logWarn(str) 
    Util.LogWarning(str);
end

function count_time_day(time_, type)
    local time_t = tonumber(time_ / 1000)
    local day = math.floor((time_t / 86400))
    local hour = math.floor((time_t % 86400 / 3600))
    local minute = math.floor((time_t % 86400 % 3600 / 60))
    if(minute == 0 and minute % 60 > 0) then
        minute = minute + 1
    end
    local time_inf = ""
    if day > 0 and type >= 1 then
        time_inf = time_inf..tostring(day).."天"
    end
    if hour > 0 and type >= 2 then
        time_inf = time_inf..tostring(hour).."小时"
    end
    if minute > 0 and type >= 3 then
        time_inf = time_inf..tostring(minute).."分钟"
    end
    return time_inf
end

function count_time(time_)
    ---1571206323000
    local time_t = tonumber(time_ / 1000)
    local hour = math.floor((time_t / 3600))
    local minute = math.floor((time_t % 3600 / 60))
    local second = math.floor((time_t % 60))
    if(minute < 10) then
        minute = stringTotable(tostring(minute))
        table.insert(minute, 1, 0)
        minute = tableTostring(minute)
    end
    if(hour < 10) then
        hour = stringTotable(tostring(hour))
        table.insert(hour, 1, 0)
        hour = tableTostring(hour)
    end
    if(second < 10) then
        second = stringTotable(tostring(second))
        table.insert(second, 1, 0)
        second = tableTostring(second)
    end
    return hour..':'..minute..":"..second
end

function stringTotable(str)
    local tab = {}
    for i = 1, string.len(str) do
        local str_ = string.sub(str, i, i)
        table.insert(tab, str_)
    end
    return tab
end

function tableTostring(tab)
    local str = ''
    for k, v in pairsByKeys(tab) do
        str = str..tostring(v)
    end
    return str
end

function pairsByKeys(t)
    local a = {}
    for n in pairs(t) do
        a[#a+1] = n
    end
    table.sort(a)
    local i = 0
    return function()
        i = i + 1
        return a[i], t[a[i]]
    end
end

function stringSplit(szFullString, szSeparator)  
    local nFindStartIndex = 1  
    local nSplitIndex = 1  
    local nSplitArray = {}  
    while true do  
       local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
       if not nFindLastIndex then  
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
        break  
       end  
       nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
       nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
       nSplitIndex = nSplitIndex + 1  
    end  
    return nSplitArray  
end

function toInt(f)
    if f < 0 then
        f = f - 0.000001
        return math.ceil(f)
    else
        f = f + 0.000001
        return math.floor(f)
    end
end

LRandom = {}
LRandom.m = 2^16
LRandom.a = 214013
LRandom.b = 2531011
LRandom.seed = 0

function LRandom.Seed(s)
    LRandom.seed = s % LRandom.m
end

function LRandom.Random(a, b)
    LRandom.seed = (LRandom.a * LRandom.seed + LRandom.b) % LRandom.m
    return toInt(a + (b - a) * LRandom.seed / LRandom.m)
end

function LRandom.RandSeq(seq)
    local all_weights = 0
    for j = 1, #seq do
        all_weights = all_weights + seq[j][2]
    end
    local result_weights = LRandom.Random(0, all_weights - 1)
    local local_weights = 0
    for j = 1, #seq do
        local_weights = local_weights + seq[j][2]
        if local_weights > result_weights then
            return seq[j][1]
        end
    end
end

function SubStringUTF8(str, startIndex, endIndex)
    if startIndex < 0 then
        startIndex = SubStringGetTotalIndex(str) + startIndex + 1;
    end

    if endIndex ~= nil and endIndex < 0 then
        endIndex = SubStringGetTotalIndex(str) + endIndex + 1;
    end

    if endIndex == nil then
        return string.sub(str, SubStringGetTrueIndex(str, startIndex));
    else
        return string.sub(str, SubStringGetTrueIndex(str, startIndex), SubStringGetTrueIndex(str, endIndex + 1) - 1);
    end
end

--获取中英混合UTF8字符串的真实字符数量
function SubStringGetTotalIndex(str)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(lastCount == 0);
    return curIndex - 1;
end

function SubStringGetTrueIndex(str, index)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(curIndex >= index);
    return i - lastCount;
end

--返回当前字符实际占用的字符数
function SubStringGetByteCount(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1;
    if curByte == nil then
        byteCount = 0
    elseif curByte > 0 and curByte <= 127 then
        byteCount = 1
    elseif curByte >= 192 and curByte <=223 then
        byteCount = 2
    elseif curByte >= 224 and curByte <= 239 then
        byteCount = 3
    elseif curByte >= 240 and curByte <= 247 then
        byteCount = 4
    end
    return byteCount;
end

function LinearBezierCurve(p0, p1, t)
    return p0 + (p1 - p0) * t
end

function QuadBezierCurve(p0, p1, p2, t)
    local B = Vector3.zero
    local t1 = (1 - t) * (1 - t)
    local t2 = t * (1 - t)
    local t3 = t * t
    return p0 * t1 + p1 * 2 * t2 + p2 * t3
end

function CubicBezierCurve(p0, p1, p2, p3, t)
    local B = Vector3.zero
    local t1 = (1 - t) * (1 - t) * (1 - t)
    local t2 = (1 - t) * (1 - t) * t
    local t3 = t * t * (1 - t)
    local t4 = t * t * t
    B = p0 * t1 + p1 * 3 * t2 + p2 * 3 * t3 + p3 * t4
    return B
end

function BezierCurve(p0, p1, p2, p3, t)
    local ax, bx, cx
    local ay, by, cy
    local tSquared, tCubed
    local result = Vector3()

    cx = 3 * (p1.x - p2.x)
    bx = 3 * (p1.x - p2.x) - cx
    ax = p3.x - p0.x - cx - bx

    cy = 3 * (p1.y - p0.y)
    by = 3 * (p2.y - p1.y) - cy
    ay = p3.y - p0.y - cy - by

    tSquared = t * t
    tCubed = tSquared * t

    result.x = (ax * tCubed) + (bx * tSquared) + (cx * t) + p0.x
    result.y = (ay * tCubed) + (by * tSquared) + (cy * t) + p0.y
    result.z = p1.z
    return result
end

function clone( object )
    local lookup_table = {}
    local function copyObj( object )
        if type( object ) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end

        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs( object ) do
            new_table[copyObj( key )] = copyObj( value )
        end
        return setmetatable( new_table, getmetatable( object ) )
    end
    return copyObj( object )
end