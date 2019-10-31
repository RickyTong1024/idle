call:compile player_db
call:compile equip_db
call:compile mail_db
call:compile mail_server_db
call:compile pet_db
call:compile rank_db
call:compile arena_list_db
call:compile arena_room_db
pause
exit

:compile
python .\tools\generate_dbo.py .\proto\%1.proto ..\server\game\common\dbo
goto:eof
