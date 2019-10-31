require "Common/define"

Game = {}

function Game.Init()
	LRandom.Seed(tostring(os.time()):reverse():sub(1, 7))
	math.randomseed(tostring(os.time()):reverse():sub(1, 7))
	resMgr.Init()
	SceneObjs.Init()
	Config.Init()	
	Message.Init()
	Hall.Init()
	Scene.Init()
	UIEffect.Init()
	GUIRoot.Init()
	GameTcp.Init()
	State.ChangeState(State.state.ss_login)
end

function Game.Finish()
	resMgr.Finish()
end