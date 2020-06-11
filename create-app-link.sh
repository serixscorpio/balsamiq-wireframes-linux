#!/bin/bash

LUTRIS_PREFIX="/${GAME_SLUG}/"
APP_LINK_NAME="balsamiq-wireframes-bmpr.desktop"
APP_LINK="${HOME}/.local/share/applications/${APP_LINK_NAME}"
APP_LINK_URL_NAME="balsamiq-wireframes-url.desktop"
APP_LINK_URL="$HOME/.local/share/applications/${APP_LINK_URL_NAME}"
WINE_PRE=$(find $HOME/ -name $LUTRIS_VER)
WINE="${WINE_PRE}/bin/wine"

FULL_EXE="${APP_EXE}"
echo FULL_EXE is "${FULL_EXE}"

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
echo "Name=${APPLICATION_NAME}" >> $APP_LINK
echo "MimeType=application/bmpr;" >> $APP_LINK
echo "Exec=env WINEPREFIX=\"${WINE_PREFIX}\" \"${WINE}\" \"${FULL_EXE}\" %f" >> $APP_LINK
echo "Categories=Wine;" >> $APP_LINK
echo "StartupWMClass=BalsamiqWireframes.exe" >> $APP_LINK
echo "" >> $APP_LINK
chmod +x $APP_LINK

# for URL schema
echo "[Desktop Entry]" > $APP_LINK_URL
echo "Type=Application" >> $APP_LINK_URL
echo "Name=${APPLICATION_NAME} Schema Handler" >> $APP_LINK_URL
echo "MimeType=x-scheme-handler/balsamiqwireframes;" >> $APP_LINK_URL
echo "Exec=env WINEPREFIX=\"${WINE_PREFIX}\" \"${WINE}\" \"${FULL_EXE}\" %u" >> $APP_LINK_URL
echo "StartupWMClass=BalsamiqWireframes.exe" >> $APP_LINK_URL
echo "" >> $APP_LINK_URL
chmod +x $APP_LINK_URL
URL_MIMETYPE="${HOME}/.local/share/mime/packages/balsamiq-wireframes-url.xml"
echo '<?xml version="1.0" encoding="UTF-8"?>' > $URL_MIMETYPE
echo '<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">' >> $URL_MIMETYPE
echo '  <mime-type type="x-scheme-handler/balsamiqwireframes">' >> $URL_MIMETYPE
echo '    <comment>Balsamiq Wireframes Url launcher</comment>' >> $URL_MIMETYPE
echo '  </mime-type>' >> $URL_MIMETYPE
echo '</mime-info>' >> $URL_MIMETYPE
chmod +x "$URL_MIMETYPE"

xdg-desktop-menu install "$APP_LINK"
xdg-desktop-menu install "$APP_LINK_URL"

xdg-mime default "$APP_LINK_NAME" application/bmpr
xdg-mime default "$APP_LINK_URL_NAME" x-scheme-handler/balsamiqwireframes

update-mime-database $HOME/.local/share/mime
update-desktop-database $HOME/.local/share/applications