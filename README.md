# ubiety_the_weather_app

A little flutter learning project.

Ubiety the weather app repository.

The app makes use of openweathermaps.org's api to fetch data.

Entirely built in flutter, the app fetches and displays weather data.

I've tried my best to round off all possible errors and fail points.

It has a little feature where it starts a countdown for sun rise/sunset depending on whatever is closer.

It also displays what the expected sunrise/sunset time is (in the location's local time).

Due to call limitations of the api, I have removed the key, in order to make the app functional:

1)Register yourself on openweathermaps.org

2)Obtain api key

3)inside lib/utilities/makeapicalls.dart , replace your api key in the const API_key , line 6
