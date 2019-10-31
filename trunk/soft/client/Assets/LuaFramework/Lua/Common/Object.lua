local ObjectConstructor = {}
ObjectConstructor.__call = function (type)

    local instance = {}
    instance.class = type
    set__gc(instance, type.prototype)
    setmetatable(instance, type.prototype)
    return instance
end

function set__gc(t, mt)
    local prox = newproxy(true)
    getmetatable(prox).__gc = function() mt.__gc(t) end
    t[prox] = true
end

Object = {}
Object.__call = ObjectConstructor.__call
Object.__index = Object

Object.prototype = {}
Object.prototype.__index = Object.prototype

function Object:subclass(typeName)
    
    -- 以传入类型名称作为全局变量名称创建table
    _G[typeName] = {}

    -- 设置元方法__index,并绑定父级类型作为元表
    local subtype = _G[typeName]

    subtype.name = typeName
    subtype.super = self
    subtype.__call = self.__call
    subtype.__index = subtype
    setmetatable(subtype, self)

    -- 创建prototype并绑定父类prototype作为元表
    subtype.prototype = {}
    subtype.prototype.__index = subtype.prototype
    subtype.prototype.__gc = self.prototype.__gc
    subtype.prototype.__tostring = self.prototype.__tostring
    setmetatable(subtype.prototype, self.prototype)
    return subtype;
end

Object.prototype.__gc = function (instance)
    --print(instance.class.name, "destroy")
end



Object.prototype.__tostring = function (instance) 
    return "[" .. instance.class.name .." object]"
end