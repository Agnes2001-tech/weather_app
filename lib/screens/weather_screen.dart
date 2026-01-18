import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController controller = TextEditingController();
  final WeatherService service = WeatherService();

  WeatherModel? weather;
  bool loading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchCity("London"); // ✅ Default city on app start
  }

  Future<void> fetchCity(String city) async {
    if (city.trim().isEmpty) return;

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final data = await service.fetchWeather(city.trim());
      setState(() => weather = data);
    } catch (e) {
      setState(() => error = "City not found or network error");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff64B5F6), Color(0xffBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: controller,
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus(); // hide keyboard
                    fetchCity(value); // ✅ Enter key works
                  },
                  decoration: InputDecoration(
                    hintText: "Enter city name",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        fetchCity(controller.text);
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Loading
                if (loading)
                  const CircularProgressIndicator(),

                // Error
                if (error != null)
                  Column(
                    children: [
                      Text(
                        error!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => fetchCity(controller.text),
                        child: const Text("Retry"),
                      )
                    ],
                  ),

                // Weather UI
                if (weather != null && !loading)
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        Text(
                          weather!.city,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "${weather!.temp.toInt()}°C",
                          style: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          weather!.description,
                          style: const TextStyle(fontSize: 20),
                        ),

                        const SizedBox(height: 40),

                        // Bottom Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildItem(
                                "💧",
                                "${weather!.humidity}%",
                                "Humidity",
                              ),
                              buildItem(
                                "💨",
                                "${weather!.wind.toStringAsFixed(1)} km/h",
                                "Wind",
                              ),
                              buildItem(
                                "🌡",
                                "${weather!.feelsLike.toInt()}°C",
                                "Feels Like",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 30)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
