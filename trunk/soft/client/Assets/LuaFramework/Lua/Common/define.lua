gameMgr = LuaHelper.GetGameManager()
panelMgr = LuaHelper.GetPanelManager()
networkMgr = LuaHelper.GetNetManager()
messMgr = LuaHelper.GetMessageManager()
soundMgr = LuaHelper.GetSoundManager()
timerMgr = LuaHelper.GetTimerManager()

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
SceneManager = UnityEngine.SceneManagement.SceneManager

json = require 'cjson'

require "Common/Object"
require "Common/State"
require "Common/Config"
require "Common/Message"
require "Common/GUIRoot"
require "Common/opcodes"
require "Common/PlayerData"
require "Common/resMgr"
require "Common/functions"
require "Common/GameSys"

require "Panel/ArtifactDetailPanel/ArtifactDetailPanel"
require "Panel/ArtifactPanel/ArtifactPanel"
require "Panel/AssetWindowPanel/AssetWindowPanel"
require "Panel/AttrChangePanel/AttrChangePanel"
require "Panel/BagPanel/BagPanel"
require "Panel/BasicUIPanel/BasicUIPanel"
require "Panel/BattlePanel/BattlePanel"
require "Panel/BookPanel/BookPanel"
require "Panel/BossPanel/BossPanel"
require "Panel/BuyPanel/BuyPanel"
require "Panel/ChangeDressPanel/ChangeDressPanel"
require "Panel/ChangeEquipPanel/ChangeEquipPanel"
require "Panel/ChangePetPanel/ChangePetPanel"
require "Panel/ChangeRunePanel/ChangeRunePanel"
require "Panel/ChangeSpellPanel/ChangeSpellPanel"
require "Panel/CommonPanel/CommonPanel"
require "Panel/DressDetailPanel/DressDetailPanel"
require "Panel/EquipDetailPanel/EquipDetailPanel"
require "Panel/EquipEnchantPanel/EquipEnchantPanel"
require "Panel/EquipEnhancePanel/EquipEnhancePanel"
require "Panel/EquipInlayPanel/EquipInlayPanel"
require "Panel/EquipPanel/EquipPanel"
require "Panel/EquipReforgePanel/EquipReforgePanel"
require "Panel/EsportsPanel/EsportsPanel"
require "Panel/ForgePanel/ForgePanel"
require "Panel/ForgeSurePanel/ForgeSurePanel"
require "Panel/HallPanel/HallPanel"
require "Panel/HallTwoPanel/HallTwoPanel"
require "Panel/LoadingPanel/LoadingPanel"
require "Panel/LoadingPixelPanel/LoadingPixelPanel"
require "Panel/MailPanel/MailPanel"
require "Panel/MapPanel/MapPanel"
require "Panel/MapTwoPanel/MapTwoPanel"
require "Panel/MaskPanel/MaskPanel"
require "Panel/MessagePanel/MessagePanel"
require "Panel/MonsterDetailPanel/MonsterDetailPanel"
require "Panel/MonsterPanel/MonsterPanel"
require "Panel/NamePanel/NamePanel"
require "Panel/NarratorPanel/NarratorPanel"
require "Panel/PassiveDetailPanel/PassiveDetailPanel"
require "Panel/PetDetailPanel/PetDetailPanel"
require "Panel/PetEnhancePanel/PetEnhancePanel"
require "Panel/PetPanel/PetPanel"
require "Panel/PetSyntPanel/PetSyntPanel"
require "Panel/PetUpgradePanel/PetUpgradePanel"
require "Panel/PlayerEquipPanel/PlayerEquipPanel"
require "Panel/PlayerPanel/PlayerPanel"
require "Panel/PlayerPetPanel/PlayerPetPanel"
require "Panel/PlayerSetPanel/PlayerSetPanel"
require "Panel/PlayerSpellPanel/PlayerSpellPanel"
require "Panel/PlayerUnlockPassivePanel/PlayerUnlockPassivePanel"
require "Panel/PlayerUnlockSpellPanel/PlayerUnlockSpellPanel"
require "Panel/PortalPanel/PortalPanel"
require "Panel/PowerChangePanel/PowerChangePanel"
require "Panel/RankPanel/RankPanel"
require "Panel/RechargePanel/RechargePanel"
require "Panel/SelectPanel/SelectPanel"
require "Panel/SellPanel/SellPanel"
require "Panel/SetingPanel/SetingPanel"
require "Panel/ShopPanel/ShopPanel"
require "Panel/ShowAssetPanel/ShowAssetPanel"
require "Panel/SignPanel/SignPanel"
require "Panel/SpellDetailPanel/SpellDetailPanel"
require "Panel/StartPanel/StartPanel"
require "Panel/TalkPanel/TalkPanel"
require "Panel/TaskPanel/TaskPanel"
require "Panel/TopResPanel/TopResPanel"
require "Panel/TouchPanel/TouchPanel"
require "Panel/TowerPanel/TowerPanel"
require "Panel/UnlockDescPanel/UnlockDescPanel"
require "Panel/UnlockPanel/UnlockPanel"
require "Panel/UsePanel/UsePanel"

require "UIControl/HpBar"
require "UIControl/ExpBar"

require "Net/GameTcp"

require "Battle/Battle"
require "Battle/Unit"
require "Battle/UnitIns"
require "Battle/FightPlayer"
require "Battle/FightManager"
require "Battle/FightAIMonster"
require "Battle/FightAIPlayer"

require "Other/AssetsChangeControl"
require "Other/Hall"
require "Other/QuestManger"
require "Other/RechargeManger"
require "Other/SceneObjs"
require "Other/Scene"
require "Other/UnlockManger"
require "Other/UIEffect"

require "protobuf/player_db_pb"
require "protobuf/player_msg_pb"
require "protobuf/item_msg_pb"
require "protobuf/equip_db_pb"
require "protobuf/mission_msg_pb"
require "protobuf/common_msg_pb"
require "protobuf/promotion_msg_pb"
require "protobuf/center_msg_pb"
require "protobuf/arena_msg_pb"
require "protobuf/arena_room_db_pb"
require "protobuf/arena_list_db_pb"

