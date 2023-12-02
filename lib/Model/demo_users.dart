import 'package:flutter/material.dart';

const users = [
  poets,
  suthar

];

const poets = DemoUser(
  id: 'phppoets',
  name: 'poets',
  image:
  "https://i.pinimg.com/originals/03/0a/61/030a6122183d6a90ad57afe118b33088.jpg",
);
const suthar = DemoUser(
  id: 'suthar',
  name: 'Himmat Suthar',
  image:
  'https://cdn-images-1.medium.com/max/1200/1*-8eOHOb93N2OMxxoQSwZoQ.png',
);



@immutable
class DemoUser {
  final String id;
  final String name;
  final String image;

  const DemoUser({
    required this.id,
    required this.name,
    required this.image,
  });
}