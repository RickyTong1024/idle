# view_player

---

## message_file 

---
### center_msg
- message
  - cmsg_view_player

    客户端发送至玩家所在服务端 查看玩家请求

    | body | type | Qualified modifier | description |
    | ---- | ---- | ------------------ | ----------- |
    | player_guid | uint64 | required | 被查看玩家guid |

  - smsg_view_player

    | body | type | Qualified modifier | description |
    | ---- | ---- | ------------------ | ----------- |
    | player_name | string | required |  |
    | player_level | int32  | required |  |
    | player_role | int32  | required  |  |
    | player_attrs_ids | int32  | repeated |  |
    | player_attrs_values | int32 | repeated |  |
    | player_equip_enhances | int32 | repeated |  |
    | player_equip_shows | int32 | repeated |  |
    | player_power | int32 | required |  |
    | player_online | bool | required |  |
    | spell_ids | int32 | repeated |  |
    | spell_levels | int32 | repeated |  |
    | spell_passive_slots | int32 | repeated |  |
    | spell_passive_ids | int32 | repeated |  |
    | player_equips | dhc.equip_t | repeated |  |
    | rune_slot1s | int32 | repeated |  |
    | rune_slot2s | int32 | repeated |  |
    | rune_slot3s | int32 | repeated |  |
    | player_pets | dhc.pet_t | repeated |  |

  - smsg_enter_center_cn

    游戏服务器向center服务器打招呼

    | body | type | Qualified modifier | description |
    | ---- | ---- | ------------------ | ----------- |
    | server_id | int32 | required | 所在服务器id |

  - smsg_heart_beat_cn

    游戏服发送 center服务器心跳消息返回

    | body | type | Qualified modifier | description |
    | ---- | ---- | ------------------ | ----------- |
    | server_id | int32 | required | 服务器id |