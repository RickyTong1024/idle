call:compile_db acc_db
call:compile_db player_db
call:compile center_msg
call:compile common_msg
call:compile player_msg
call:compile arena_msg
call:compile item_msg
call:compile mission_msg
call:compile promotion_msg
call:compile_db equip_db
call:compile_db mail_db
call:compile_db mail_server_db
call:compile_db pet_db
call:compile_db rank_db
call:compile_db arena_list_db
call:compile_db arena_room_db
pause
exit

:compile
.\tools\protoc.exe -I=.\proto --python_out=..\server\game\common\proto .\proto\%1.proto
call:compile_pkg %1
goto:eof

:compile_pkg
python .\tools\change_pkg_proto.py ..\server\game\common\proto\%1_pb2.py
goto:eof

:compile_db
call:compile %1
python .\tools\change_db_proto.py ..\server\game\common\proto\%1_pb2.py .\proto\%1.proto
goto:eof