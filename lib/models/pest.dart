class Pest {
  final int id;
  final String scientificName;
  final String persianName;
  final String commonName;
  final String description;
  final String damage;
  final String control;
  final String host;
  final String distribution;
  final String quarantineClass;

  const Pest({
    required this.id,
    required this.scientificName,
    required this.persianName,
    required this.commonName,
    required this.description,
    required this.damage,
    required this.control,
    required this.host,
    required this.distribution,
    required this.quarantineClass,
  });
}