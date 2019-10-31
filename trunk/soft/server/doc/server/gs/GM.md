# GM相关

## 相关命令

| 命令          | 功能                 | 示例                |
| ------------- | -------------------- | ------------------- |
| addasset      | 添加资源/道具/装备等 | addassets1 1 1000 0 |
| refresh_day   | 刷新天               |                     |
| refresh_week  | 刷新周               |                     |
| refresh_month | 刷新月               |                     |
| create_mail   | 创建随机邮件         |                     |

addreward type类型说明：addreward type arg1 arg2 arg3

- 1 资源类型      addasset1 1 100 0            //添加100金币
  - 1 金币 2 钻石 3 经验 4 荣誉 5 神器能量 6 宠物能量 7 刷子等级
- 2 道具类型       addasset 2 30020001 10 0           //添加10强化石
- 3 装备类型       addasset tp value1 value2 value3               //添加1-10级武器 武器为九级 品质为5
  - 装备 数字参数 tp为装备类型 即3 value1为装备template_id value2为装备等级(随机最低等级+value2 如果value2为空则随机) value3为装备品质（若value3为0则随机）
- 4 神器类型      同道具类型
- 5 符文类型      同道具类型
- 6 宠物类型      addasset  6 pet_id 0 0
- 7 宠物经验      addasset  7  1 pet_id exp 

| opcode          | 客户端消息      | 服务端消息      | 备注       |
| --------------- | --------------- | --------------- | ---------- |
| CMSG_GM_COMMAND | cmsg_gm_command | smsg_gm_command | 发送GM命令 |