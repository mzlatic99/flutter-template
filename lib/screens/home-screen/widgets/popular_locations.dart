import 'package:flutter/material.dart';
import '../../../models/location.dart';
import '../../../http.dart';
import '../../../shared/popular_locations_card.dart';
import '../../../theme.dart';

class PopularLocations extends StatelessWidget {
  const PopularLocations({
    Key? key,
    required List<LocationCard> locationCardList,
  })  : _locationCardList = locationCardList,
        super(key: key);

  final List<LocationCard> _locationCardList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular locations',
                style: textTheme.headline5,
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'VIEW MORE',
                    style: textTheme.button!.merge(
                      TextStyle(
                        color: ThemeColors.mint400,
                      ),
                    ),
                  ))
            ],
          ),
        ),
        FutureBuilder(
          future: http.getPopularLocations(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('error'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: ThemeColors.mint500,
              ));
            }
            List<Location> locations = snapshot.data;
            for (var location in locations) {
              _locationCardList.add(LocationCard(
                  id: location.id,
                  locationImage: location.imageUrl,
                  locationName: location.locationName,
                  locationProperties: location.properties));
            }
            return GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              crossAxisCount: 2,
              children: _locationCardList,
            );
          },
        ),
      ],
    );
  }
}
