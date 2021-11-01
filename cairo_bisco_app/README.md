# K visuals

Project for Kellogg's Bisco Misr Cairo Plant

## deployment instructions :
1. delete all contents of build/web

2. Build for web :
   > flutter build web --web-renderer html --release --no-sound-null-safety
3. Move build/web --> /public 3.1 Move firestore.indexes.json , firebase.json , firestore.rules -->
   /public - if changed -

4. You can test locally before deployment
   > firebase serve --only hosting
5. Deploy a new release
   > firebase deploy --only hosting:bisco-k-visuals
6. Use [deployment URL](https://bisco-k-visuals.web.app)
   > https://bisco-k-visuals.web.app
