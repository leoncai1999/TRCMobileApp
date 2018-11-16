# TRCMobileApp
This is a mobile application for our intramural running club. Its main features include: 
Being able to vote on each day's route, A Map that shows all of our routes, 
an activity feed showing members Strava posts, a news feed that shows a timeline of tweets
from a variety of running accounts and additional features such as viewing the schedule
and being able to sign up for the Email list. 

Language: Swift 

Frameworks Used: Apple MapKit, Apple WebKit, TwitterKit, Firebase Database

API's Used: Strava API, Twitter API

NOTE: If attempting to recreate this app, you will need to do the following:
1) Register for a Twitter Developer Account. Then create an App, and obtain the consumer
API keys from your app. Then in AppDelegate.Swift, replace keys.TwitterKey and 
keys.TwitterSecret with your own keys.
2) Create a Strava Account, and then create an App as a Strava Developer. Obtain a Strava
API Key and in NewsFeedController.Swift, replace keys.StravaKey with your own key. 
3) Create a Firebase Database for your project via the Google Play Developer Console. This
will be used to store polling data for the routes in real time

Screenshots:

[![Poll](https://i.postimg.cc/0N474zXK/TRCApp-Poll.png)](https://postimg.cc/4KzK7xgX)
[![Routes](https://i.postimg.cc/MH2VWhSW/TRCApp-Routes.png)](https://postimg.cc/47PmP2yM)
[![Member Activities](https://i.postimg.cc/rmt52q7n/TRCApp-Strava.png)](https://postimg.cc/HcdrQ1YX)
[![News Feed](https://i.postimg.cc/CK5jJG7V/TRCApp-Twitter.png)](https://postimg.cc/Ty8L3WBk)
