del ..\client\Assets\LuaFramework\Lua\protobuf\*.lua

call:compile player_db
call:compile center_msg
call:compile common_msg
call:compile player_msg
call:compile arena_msg
call:compile item_msg
call:compile mission_msg
call:compile promotion_msg
call:compile equip_db
call:compile mail_db
call:compile pet_db
call:compile rank_db
call:compile arena_list_db
call:compile arena_room_db
pause
exit

:compile
.\tools\protoc.exe --plugin=protoc-gen-lua=".\tools\protoc-gen-lua.bat" -I=.\proto --lua_out=..\client\Assets\LuaFramework\Lua\protobuf .\proto\%1.proto
goto:eof