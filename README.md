# 🍞 Crust 1.2.0

🍞 Toast would not be toast without the crust

✨ Flutter, Dart, consuming data from the GraphQL API [Toaster](https://github.com/psyanite/toaster)

🔥 Download and install the APK [now](https://github.com/psyanite/crust/blob/master/docs/burntoast-1.2.0.apk)!

## Features
* Register via Facebook or Google now!
* View all available stores and rewards
* Favorite rewards so you can keep them handy at all times
* Request a one-time unique QR code ready for redeeming at the store
* Visit your friends' profiles
* Read reviews on others' experiences

## Next Release Preview
* Pagination/Forever-scroll
* Ability to search for keywords in suburbs such as "Cafes in CBD"
* Create a new post

## Implementation
* Implements Presenter-Props model
* Transforms GraphQL requests into Dart models stored in Redux using Thunk
* Custom design and branding
* All assets and icons created via Adobe Illustrator
* Implements [custom icons](https://medium.com/flutterpub/how-to-use-custom-icons-in-flutter-834a079d977)
* Search for stores using `showSearch` and fulltext PostgreSQL search
* Custom Instagram-like experience carousel implementation for viewing multiple photos 
* Implements a Instagram-like main tab navigator
* Implements Sliver components for greater flexibility
* Switch between list items and cards viewing available rewards
* Persists session data into local device using `redux-persist` and `flutter-storage`

<div align="center">
  <img src="https://github.com/psyanite/crust/blob/master/docs/images/splash.jpg" width="250px"/>
  <img src="https://github.com/psyanite/crust/blob/master/docs/images/home.jpg" width="250px"/>
  <img src="https://github.com/psyanite/crust/blob/master/docs/images/profile.jpg" width="250px"/>
  <img src="https://github.com/psyanite/crust/blob/master/docs/images/store.jpg" width="250px"/>
  <img src="https://github.com/psyanite/crust/blob/master/docs/images/rewards.jpg" width="250px"/>
  <img src="https://github.com/psyanite/crust/blob/master/docs/images/favorites.jpg" width="250px"/>
  <img src="https://github.com/psyanite/crust/blob/master/docs/images/search.jpg" width="250px"/>
</div>

## To Do
* Re-test create/edit posts
* Add write a review button from store screen
* Fetch recommendations
* Fix new post page to show location of store
* Are you sure you want to quit? https://stackoverflow.com/questions/49356664/how-to-override-the-back-button-in-flutter
* Implement comments
* Implement pagination

## Done
* Implement pull to refresh on store screen
* Implement pull to refresh on my profile screen
* Implement pull to refresh on profile screen
* Implement search screen
* Implement search location screen
* Implement location_search table
* Implement cuisine_search table
* Add edit post feature
* Add delete post feature
* Validate file size maximum 5000x5000
* Add keys everywhere
* Add like post feature
* Skeleton homepage
* Order store and profile page posts chronologically
* Implement store banner
* Implement post list on store page
* Implement post list on profile page
* Implement login with Facebook
* Implement login with Google
* Implement logout
* Implement profile page
* Implement my profile page
* Implement profile header
* Implement home page
* Implement favorites on home page and rewards page
* Implement rewards page
* Implement rewards card view
* Implement rewards list view
* Implement favourites page
* Implement session persist on me state
* Implement main tab navigator
* Implement search store 
* Implement write a review page
* Implement review form
* Compress images before upload
* Upload photos to firebase
* Cache network images on post lists
