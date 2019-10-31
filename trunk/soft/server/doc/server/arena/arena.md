# 竞技场

---
## message_file 

---
### arena_msg

- opcode
  - CMSG_ARENA_ROOM
    查看竞技场所在房间信息请求
    None msg

  - SMSG_ARENA_ROOM
    查看竞技场所在房间信息请求返回消息
    smsg_arena_message

    | body | type | Qualified modifier | description |
    | ---- | ---- | ------------------ | ----------- |
    | arena_room | arena_room_t | required | 房间实体 |

  - CMSG_ARENA_FIGHT_INIT
    玩家战斗初始化（获取对手玩家战斗数据）
    cmsg_arena_fight_init

    | body | type | Qualified modifier | description |
    | ---- | ---- | ------------------ | ----------- |
    | guid | uint64 | required | 玩家guid |
    | name | string | required | 玩家昵称 |
    | level | int32 | required | 玩家等级 |
    | role_id | int32 | required | 角色id |
    | attr_ids | int32 | repeated | 属性id |
    | attr_values | int32 | repeated | 属性值 |
    | spell_ids | int32 | repeated | 技能id |
    | spell_levels | int32 | repeated | 技能等级 |
    | spell_passive_slots | int32 | repeated | 被动槽 |
    | equip_shows | int32 | repeated | 显示装备 |
    | equips | equip_t | repeated | 装备 |
    | pets | pet_t | repeated | 宠物 |

  - CMSG_ARENA_FIGHT
    竞技场战斗结束同步消息
    cmsg_arena_fight

    | body | type | Qualified modifier | description |
    | ---- | ---- | ------------------ | ----------- |
    | win | bool | required |  获胜/失败 |

  - SMSG_ARENA_FIGHT
    竞技场战斗结束同步消息
    smsg_arena_fight

    | body | type | Qualified modifier | description |
    | ---- | ---- | ------------------ | ----------- |
    | seed | int32 | required |  战斗随机种子 |
    | arena_integral | int32 | required |  积分 |
    | arena_win | int32 | required |  获胜 |
    | arena_num | int32 | required |  失败 |