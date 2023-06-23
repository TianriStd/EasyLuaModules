
Except = {}

local Error = {}
Error["ctx"] = "TryError"
Error["ctx_catch"] = "CatchError"

---@param code function
---@param catch function
---@return boolean|string
---通过代码与错误尝试来进行错误处理
---
---# 示例
---```
---function TFunc()
---    for index, value in ipairs(t) do
---        
---    end
---end
---function CFunc()
---    print("err")
---end
---Except.Try(TFunc,CFunc)
---```
---结果是err 与 false 发生于遍历一个不存在的变量
function Except.Try(code,catch)
    local cotype = type(code) --?获取code类型
    local catype = type(catch) --?获取catch类型
    local errors = {} --?记录error
    local eis --?判断errors是内容否为true
    local lresult = nil --?定义结果
    

    if cotype == "function" then --?参数code类型是否为函数function
        lresult = pcall(code)  --?执行代码并将结果返回
    else
        lresult = Error
        errors[0] = true      
    end

    --! catch相关
    if catype == "function" then
        if lresult == false or lresult == Error then
            catch()
        end
    elseif catype ~= "nil" then
        errors[1] = true
    end

    --! 错误相关
    if errors[0] and errors[1] then
        eis = 2
    elseif errors[0] or errors[1] then
        eis = 1
    end

    if lresult ~= nil and lresult ~= Error then --!如果结果不等于nil且结果不等于Error时执行
        return lresult --?返回结果
    elseif lresult == Error then --?结果等于Error时，返回Error
        if eis == 1 then
            return Error["ctx"]
        elseif eis == 2 then
            return Error["ctx"],Error["ctx_catch"]
        end
        
    end
end

return Except

