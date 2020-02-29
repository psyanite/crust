# 🍞 Crust

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
d
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

* Send email to Joe

Toaster:
* DEV DB
* PROD DB

Crust & Butter:
* DEV GraphQL endpoint
* PROD GraphQL endpoint

* Facebook Login
* Google Login
* Help page on the login/signup page
* Show private posts, and all posts on the homepage post list on the Admin app

* Fix up other stores search screen
* Fix Write A Review screen
* Migrate changes to butter

* Convert icon to blue
* Move photos away from Zomato

* Polish database for production
* Edit my profile ^_^

* Enable login via iOS
* Enable flutter_local_notifications on iOS
* Enable push notifications in iOS
* Test on iOS
* Enable firebase dynamic urls in iOS

* Migrate database to Google Cloud
* Migrate server to Google Cloud
* Backup FirebaseStorage using Google Cloud Archive
* Export database every night
* Write Cloud Function to call endpoint to do database cleanup
* Backup Firebase Storage

* Set notifications / alerts on Google AppEngine
https://medium.com/google-cloud/three-simple-steps-to-save-costs-when-prototyping-with-app-engine-flexible-environment-104fc6736495
https://cloud.google.com/billing/docs/how-to/budgets
https://stackoverflow.com/questions/47125661/pricing-of-google-app-engine-flexible-env-a-500-lesson

================================================================

* Add loading dialog on delete post
* Add page refresh on my profile
* Add on tap of cuisine to open search page

* Add link previews to dynamic links
* Send email of results

* Fix location_search uses union all but has duplicates

## Done
* Add admin-user comment, post, reply notifications
* Migrate Butter to AndroidX
* Fix up stores search screen
* Import stores from Zomato
* Implement store posts
* Update store posts
* Delete store posts
* Add submit missing store feature
* Add stores screen
* Add loyalty rewards screen
* Add redeem reward behaviour
* Add buy 10 get 1 free rewards
* Implemented home screen on butter
* Implemented register on BUtter
* Implemented login on Butter
* Made Butter App
* Change Header on home screen feed posts
* Update the store mutation endpoint to save point data correctly
* Implement reward feed
* Refactor store curates
* Add search rewards functionality
* Refactor out FetchNearMe action
* Add coords consideration into rewards
* Add coords consideration into store search
* Create new column in store table
* Populate store table with point data
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

## Get started
* Move `crust.jks` into `/android/app`
* Move `google-services.json` into `/android/app`
* Move `key.properties` into `/android`

## How to Release
1. Update `config.dart`
1. Update `pubspec.yaml`
1. Run `flutter build appbundle`
