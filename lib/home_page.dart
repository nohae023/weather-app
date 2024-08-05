import 'package:flutter/material.dart';
import 'package:weather_app/api.dart';
import 'package:weather_app/weathermodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiResponse? response;
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff05406B),
        body: Container(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              _buildSearchWidget(),
              SizedBox(
                height: 10,
              ),
              if (inProgress)
                CircularProgressIndicator()
              else
                Expanded(
                    child: SingleChildScrollView(child: _buildWeatherWidget())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return SearchBar(
      hintText: "Search City",
      onSubmitted: (value) {
        _getWeatherData(value);
      },
    );
  }

  Widget _buildWeatherWidget() {
    if (response == null) {
      return Text(" Search for the City to get weather data");
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.location_on,
                size: 50,
                color: Colors.white,
              ),
              Text(
                response?.location?.name ?? "",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                response?.location?.country ?? "",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 150,
            child: Image.network(
              "http:${response?.current?.condition?.icon}"
                  .replaceAll("65x65", "150x150"),
              scale: 0.9,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (response?.current?.tempC.toString() ?? "") + " °c",
                style: TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Text(
            (response?.current?.condition?.text.toString() ?? "") + "",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          Card(
            elevation: 4,
            color: Color(0xff22699D),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget("Feels Like",
                        (response?.current?.tempC.toString() ?? "") + " °c"),
                    _dataAndTitleWidget("Humidity",
                        response?.current?.humidity?.toString() ?? ""),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget(
                        "UV", response?.current?.uv?.toString() ?? ""),
                    _dataAndTitleWidget("Perciptation",
                        " ${response?.current?.precipMm?.toString() ?? ""} mm"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget("Local Time",
                        response?.location?.localtime?.split(" ").last ?? ""),
                    _dataAndTitleWidget("Local Date",
                        response?.location?.localtime?.split(" ").first ?? ""),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _dataAndTitleWidget(String title, String data) {
    return Padding(
      padding: EdgeInsets.all(18.0),
      child: Column(
        children: [
          Text(
            data,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xffFFFFFF),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xff87C1EB),
            ),
          ),
        ],
      ),
    );
  }

  _getWeatherData(String City) async {
    setState(() {
      inProgress = true;
    });

    try {
      response = await WeatherApi().getCurrentWeather(City);
    } catch (e) {
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
