# brv-main
FiveM代码试验场

##当前进度 11-25
-修复完善线上地图和自制地图JSON加载器 耗时四个小时
-删除数据库依赖
##待办
-完善地图制作器
-添加游戏玩法
```
ensure mapmanager
ensure spawnmanager
ensure sessionmanager
ensure hardcap
ensure rconlog
ensure loadscreen
ensure chat
ensure chat-theme
start mods
start warmenu
#start mysql-async
start main
```
-- 学习使用README！
用`main/server/rconlog_server.lua`替换rconlog原文件才能使用机器人
- bash /Fuzzys/server/run.sh +exec server.cfg 2>&1 | tee -a log.txt
- {"mission":{"prop":{"model":[],"loc":[],"no":0,"vRot":[]}}}