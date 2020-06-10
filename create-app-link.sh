#!/bin/bash

APP_NAME="Wine $APPLICATION_NAME"
APP_NAME_TRIMMED="${APPLICATION_NAME// /}"
LUTRIS_PREFIX="/$GAME_SLUG/"
APP_LINK="$HOME/.local/share/applications/$APP_NAME_TRIMMED.desktop"

WINE_PRE=$(find $HOME/ -name $LUTRIS_VER)
WINE="${WINE_PRE}/bin/wine"

FULL_EXE=$APP_EXE
echo FULL_EXE is $FULL_EXE

# split wine prefix from the windows executable and keep both
pattern='^([^.]*)\/drive_c\/(.*)'
[[ $FULL_EXE =~ $pattern ]]
WINE_PREFIX=${BASH_REMATCH[1]}
RAW_PATH=${BASH_REMATCH[2]}
RAW_SUBS=$(echo $RAW_PATH | tr / \\\\ )
EXE=C:\\${RAW_SUBS}

# wite the application.desktop file (useful for 'open with' desktop integration)
echo "[Desktop Entry]" > $APP_LINK
echo "Type=Application" >> $APP_LINK
echo "Name=${APP_NAME}" >> $APP_LINK
echo "MimeType=application/bmpr;" >> $APP_LINK
echo Exec= env WINEPREFIX=\"$WINE_PREFIX\" \"$WINE\" \"$EXE\" %f >> $APP_LINK
echo "Categories=Wine;" >> $APP_LINK