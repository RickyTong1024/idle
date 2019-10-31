WWW = UnityEngine.WWW
WWWForm = UnityEngine.WWWForm
PlayerPrefs = UnityEngine.PlayerPrefs
GameObject = UnityEngine.GameObject
AnimationCurve = UnityEngine.AnimationCurve
Keyframe = UnityEngine.Keyframe
Camera = UnityEngine.Camera
RectTransformUtility = UnityEngine.RectTransformUtility
RectTransform = UnityEngine.RectTransform
Screen = UnityEngine.Screen
Input = UnityEngine.Input
KeyCode = UnityEngine.KeyCode
Physics = UnityEngine.Physics
EventSystem = UnityEngine.EventSystems.EventSystem
PointerEventData = UnityEngine.EventSystems.PointerEventData
Random = UnityEngine.Random
LayerMask = UnityEngine.LayerMask
AssetBundle = UnityEngine.AssetBundle
LayoutUtility = UnityEngine.UI.LayoutUtility
LayoutRebuilder = UnityEngine.UI.LayoutRebuilder
ColorUtility = UnityEngine.ColorUtility
DOTween = DG.Tweening.DOTween
Texture2D = UnityEngine.Texture2D

require "Common/Object"
require "Common/Config"
require "Common/functions"
require "Common/GameSys"
require "Common/resMgr"

require "Battle/Battle"
require "Battle/Unit"
require "Battle/UnitIns"
require "Panel/BattlePanel/BattlePanel"
require "Other/Scene"

panelMgr = nil
TestBattle = {}
GUIRoot = nil

local my_role_id
local enemy_role_id


function TestStart(params)
	print("testbattle - start")
	resMgr.Init()
	panelMgr = params[0]
	timerMgr = params[1]
	my_role_id = params[2]
	enemy_role_id = params[3]
	Scene.Init()
	Scene.Show("zdbj_001")
	Config.Init()
	GUIRoot = Scene.UnitRoot
	TestBattle.Init()

end

local u1 = nil
local u2 = nil
local show_spell_ids = {}
function TestBattle.Init()
	UpdateBeat:Add(TestBattle.Update, TestBattle)
	Battle.common_behaviour_list = Battle.GetBehaviours("unit_common")
	Battle.common_effect_points = Battle.GetUnitEffectPoint("unit_common")
	u1 = Unit.CreateUnit(0, "aa", 1, 100, my_role_id)
	u2 = Unit.CreateUnit(10, "aa", 1, 100, enemy_role_id)
	Battle.InitShow()
	Battle.units = {
		[0] = u1,
		[10] = u2
	}
end

local const_hurt_time = 0.5
local hurt_time = 0.5

function TestBattle.Update()
	for i = #show_spell_ids , 1, -1 do
		local info = show_spell_ids[i]
		info.timer = info.timer + Time.deltaTime * info.speed
		if info.timer >= hurt_time then
			u1:ShowSpellEffect(info.spell_id)
			local t_spell = Config.get_config_value("t_spell", info.spell_id)
			if t_spell.dmg_type ~= 0 then
				u2:White()
			end
			table.remove(show_spell_ids, i)
		end
	end
end

local attack_index = 1

function TestBattle.SetAttackIndex(index)
	attack_index = index
end

function TestBattle.TestSpell(spell_id, attack_speed)
	local cur_t_spell = Config.get_config_value("t_spell", spell_id)
	local action_name = cur_t_spell.action
	u1.attack_action_index = attack_index
	hurt_time = const_hurt_time / attack_speed
	u1.attack_speed = attack_speed
	print(action_name)
	u1:ShowBehaviour(action_name)
	TestBattle.SetShowEffect(spell_id, attack_speed)
end

function TestBattle.SetShowEffect(id, speed_)
	table.insert(show_spell_ids, {
		spell_id = id,
		timer = 0,
		speed = speed_
	})
end

function TestBattle.TestAttachStart(id)
	u1:AttachStart(id)
end

function TestBattle.TestEndAttach(id)
	u1:AttachEnd(id)
end


function TestBattle.TestShowBehaviour(name)
	u1:ShowBehaviour(name)
end

function TestBattle.ChangeRole(role_1, role_2)
	if my_role_id ~= role_1 then
		u1:Destroy()
		my_role_id = role_1
		u1 = Unit.CreateUnit(0, "aa", 1, 100, my_role_id)
	end
	if enemy_role_id ~= role_2 then
		u2:Destroy()
		enemy_role_id = role_2
		u2 = Unit.CreateUnit(10, "aa", 1, 100, enemy_role_id)
	end
	Battle.InitShow()
end
