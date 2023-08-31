import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:nocrime/models/place_model.dart';

class CctvMapScreen extends StatefulWidget {
  const CctvMapScreen({super.key});

  @override
  State<CctvMapScreen> createState() => _CctvMapScreenState();
}

class _CctvMapScreenState extends State<CctvMapScreen> {
  Set<Marker> markers = {};
  late Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();
  late ClusterManager clusterManager;
  final List<PlaceModel> placeList = []; // 위도와 경도 데이터 저장을 위한 리스트

  @override
  void initState() {
    clusterManager = _initClusterManager();
    super.initState();
    _loadCoordinates(); // 위도와 경도 데이터를 불러오는 함수 호출
  }

  Future<void> _loadCoordinates() async {
    final csvString = await rootBundle.loadString('assets/cctv.csv');
    final csvData = const CsvToListConverter()
        .convert(csvString.replaceAll(",", " ").replaceAll("\n", ","))[0];

    setState(() {
      var idx = 1;
      for (final row in csvData) {
        try {
          final lat = double.tryParse(row.split(" ")[0].toString());
          final lng = double.tryParse(row.split(" ")[1].toString());
          if (lat != null && lng != null) {
            placeList.add(PlaceModel(id: idx, latLng: LatLng(lat, lng)));
          }
        } catch (e) {
          print(e);
        }
        idx += 1;
      }
    });
  }

  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(36, 128),
    zoom: 7.0,
  );

  ClusterManager _initClusterManager() {
    return ClusterManager<PlaceModel>(placeList, _updateMarkers,
        markerBuilder: markerBuilder);
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      this.markers = markers;
    });
  }

  Future<Marker> Function(Cluster<PlaceModel>) get markerBuilder =>
      (cluster) async {
        return Marker(
            markerId: MarkerId(cluster.isMultiple
                ? cluster.getId()
                : cluster.items.single.id.toString()),
            position: cluster.location,
            icon: await BitmapDescriptor.fromAssetImage(
                const ImageConfiguration(size: Size(20, 20)),
                'assets/images/cctv.png'));
      };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 550, // Set an appropriate height
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(20), // Add this line for rounded corners
        ),
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          myLocationEnabled: true, // Show user's location
          markers: markers,
          onMapCreated: (GoogleMapController controller) async {
            googleMapController.complete(controller);
            clusterManager.setMapId(controller.mapId);
          },
          onCameraMove: (position) {
            clusterManager.onCameraMove(position);
          },
          onCameraIdle: clusterManager.updateMap,
          // 제스처를 이용해 확대, 축소
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
        ),
      ),
    );
  }
}
