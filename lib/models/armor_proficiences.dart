import 'armor.dart';

final Map<String, List<ArmorType>> classArmorProficiencies = {
  "Mago": [ArmorType.none],
  "Feiticeiro": [ArmorType.none],
  "Bárbaro": [ArmorType.none, ArmorType.light, ArmorType.medium], // escudo tratado à parte
  "Bruxo": [ArmorType.light],
  "Monge": [ArmorType.none],
  "Clérigo": [ArmorType.light, ArmorType.medium],
  "Paladino": [ArmorType.light, ArmorType.medium, ArmorType.heavy],
  "Guerreiro": [ArmorType.light, ArmorType.medium, ArmorType.heavy],
  "Patrulheiro": [ArmorType.light, ArmorType.medium],
  "Druida": [ArmorType.light, ArmorType.medium],
  "Ladino": [ArmorType.light],
  "Bardo": [ArmorType.light],
};
