del ..\soft\client\Assets\res\config\*.txt
del ..\soft\client\Assets\res\config\*.txt.meta
del ..\soft\server\game\config\*.txt

python conv_UTF8.py ../soft/client/Assets/res/config/
python conv_UTF8.py ../soft/server/game/config/
pause
