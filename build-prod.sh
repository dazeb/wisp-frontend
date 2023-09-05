#!/bin/bash

read -p "Do you want to rebuild? [y/N]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
   npm run build
fi

mkdir -p dist/assets && mv dist/panel dist/assets

if ! grep -q BaseURL "dist/index.html"; then
   source .env
   sed -i "1i<script>\n    window.Wisp = {Debug: true, Node: \'local\', Version: \'dev\', BaseURL: \'$VITE_PANEL_URL\' };\n</script>\n" dist/index.html
fi

cd dist || {
   echo "Failed changing to dist directory"
   exit 1
}

printf "Common issues:\n - Make sure you have third party cookies enabled for the site.\n - Disable cors on your browser.\n\n"
python3 -m http.server --bind 127.0.0.1
cd ../
