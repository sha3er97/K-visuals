# K visuals

Project for Kellogg's Bisco Misr Cairo Plant

## deployment instructions :

1. delete all contents of build/web

2. Build for web :
   > flutter build web --web-renderer html --release --no-sound-null-safety
3. Move build/web --> /public
4. Move firestore.indexes.json , firebase.json , firestore.rules -->
   /public - if changed -
5. You can test locally before deployment
   > firebase serve --only hosting
6. Deploy a new release
   > firebase deploy --only hosting:bisco-k-visuals
   >
   > firebase deploy --only hosting:factory-tracker-visuals

7. Use [deployment URL](https://bisco-k-visuals.web.app) or
   new [deployment URL](https://factory-tracker-visuals.web.app)
   > https://bisco-k-visuals.web.app
   > https://factory-tracker-visuals.web.app

## export apk

> flutter build apk --release --no-sound-null-safety

## export app bundle

> flutter build appbundle --no-sound-null-safety