require "Game"

--主入口函数。从这里开始lua逻辑
function Main()
	--游戏初始化
	Game.Init()
end

function MainEnd()
	Game.Finish()
end
