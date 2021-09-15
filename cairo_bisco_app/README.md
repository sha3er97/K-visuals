# cairo_bisco_app

Project for Bisco Misr Cairo Plant

## deployment instructions :

1. Build for web :
   > flutter build web --no-sound-null-safety
2. Move build/web --> /public 2.1 Move firestore.indexes.json , firebase.json , firestore.rules -->
   /public - if changed -

3. You can test locally before deployment
   > firebase serve --only hosting
4. Deploy a new release
   > firebase deploy --only hosting:bisco-k-visuals
5. Use [deployment URL](https://bisco-k-visuals.web.app)
   > https://bisco-k-visuals.web.app
