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
![Poll](https://dochub.com/leoncai/Qr5xnR/trcapppoll-png?dt=NcmQoVovTnMQhawjVwKt)
![Routes](https://drive.google.com/file/d/1Z_XPYyVrth0l0tWw0eXORCRIgiM_jkxn/)
![Member Activities](https://drive.google.com/file/d/1ApqtF3admpLHpiqTtaSFHTVmLG5Ecb-y/)
![News Feed](https://drive.google.com/file/d/1havdweXoWrW1uobrWuwebA0vgzmqQ_RY/)
