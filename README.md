# 🍞 Crust 2.0.0

🍞 Toast would not be toast without the crust

✨ Flutter, Dart, consuming data from the GraphQL API [Toaster](https://github.com/psyanite/toaster)

🔥 Download and install the APK [now](https://github.com/psyanite/crust/blob/master/docs/burntoast-2.0.0.apk)!

## Features
* Register via Facebook or Google now!
* View all available stores and rewards
* Favorite rewards so you can keep them handy at all times
* Request a one-time unique QR code ready for redeeming at the store
* Visit your friends' profiles
* Read reviews on others' experiences

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
* Change Header on home screen feed posts
* Handle reward feed
* Search rewards

* Implement store posts
* Add submit missing store feature
* Enable firebase dynamic urls in iOS
* Add link previews to dynamic links
* Enable login via iOS
* Run nightly task to update caches
* Send email of results

## Done
* Implement pagination
* Implement pull to refresh
* Browse rewards
* Add bearer token to server environment
* Directions
* Curate some lists for better exploring stores experience
* Update tagline to be multiline
* Implement follow functionality
* Add follow button on profile
* Add follow button on store
* Add update profile features
* Show store posted posts on store page
* Add RewardSwiper to StoreScreen
* Show store-exclusive rewards
* Allow multiline text on post submission
* Allow multiline text on terms and conditions
* Implement top stores and top rewards on home screen
* Display store locations on reward screen
* Enable user to scan and save a reward from a QR code
* Implement QR scanner
* Implement firebase dynamic urls
* Implement secret rewards
* Move like button reward screen
* Update favorite store and reward behaviour to be instant
* Add write a review button from store screen
* Implement comment count
* Implement comments
* Update store screen for multiple same user posts
* Mark hidden posts on my profile
* Fetch hidden and public posts for me
* Update new post form to have secret/public option
* Update edit post form to have secret/public option
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

## How to Release
1. Open `config.dart`
1. Update `appFlavor` to `Flavor.RELEASE`
1. Run `flutter build apk`
1. Copy apk file from build dir into docs
1. If upgrading version number update two places in `README.md`
