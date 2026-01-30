/// Border frame model for QR code decoration
class BorderFrame {
  final String id;
  final String name;
  final String category;
  final String assetPath;
  final String? description;

  const BorderFrame({
    required this.id,
    required this.name,
    required this.category,
    required this.assetPath,
    this.description,
  });
}

/// Border categories
enum BorderCategory {
  punk('Punk Rock'),
  cyber('Cyberpunk'),
  edgy('Hard/Edgy'),
  creature('Creatures'),
  cat('Cats'),
  kawaii('Kawaii');

  final String displayName;
  const BorderCategory(this.displayName);
}

/// All available border frames
class BorderFrames {
  static const List<BorderFrame> all = [
    // PUNK ROCK (5)
    BorderFrame(
      id: 'punk_torn',
      name: 'Torn Paper',
      category: 'Punk Rock',
      assetPath: 'assets/borders/punk_torn.png',
      description: 'Ripped edges with safety pins',
    ),
    BorderFrame(
      id: 'punk_pins',
      name: 'Pins & Chains',
      category: 'Punk Rock',
      assetPath: 'assets/borders/punk_pins.png',
      description: 'Safety pins and chains',
    ),
    BorderFrame(
      id: 'punk_grunge',
      name: 'Grunge',
      category: 'Punk Rock',
      assetPath: 'assets/borders/punk_grunge.png',
      description: 'Spray paint drips',
    ),
    BorderFrame(
      id: 'punk_anarchy',
      name: 'Anarchy',
      category: 'Punk Rock',
      assetPath: 'assets/borders/punk_anarchy.png',
      description: 'Anarchy symbols',
    ),
    BorderFrame(
      id: 'punk_chains',
      name: 'Chain Links',
      category: 'Punk Rock',
      assetPath: 'assets/borders/punk_chains.png',
      description: 'Metallic chains',
    ),

    // CYBERPUNK (5)
    BorderFrame(
      id: 'cyber_glitch',
      name: 'Glitch',
      category: 'Cyberpunk',
      assetPath: 'assets/borders/cyber_glitch.png',
      description: 'Neon glitch effects',
    ),
    BorderFrame(
      id: 'cyber_neon',
      name: 'Neon Grid',
      category: 'Cyberpunk',
      assetPath: 'assets/borders/cyber_neon.png',
      description: 'Retro futuristic grid',
    ),
    BorderFrame(
      id: 'cyber_circuit',
      name: 'Circuit Board',
      category: 'Cyberpunk',
      assetPath: 'assets/borders/cyber_circuit.png',
      description: 'Electronic traces',
    ),
    BorderFrame(
      id: 'cyber_matrix',
      name: 'Matrix Code',
      category: 'Cyberpunk',
      assetPath: 'assets/borders/cyber_matrix.png',
      description: 'Falling code',
    ),
    BorderFrame(
      id: 'cyber_holo',
      name: 'Holographic',
      category: 'Cyberpunk',
      assetPath: 'assets/borders/cyber_holo.png',
      description: 'Iridescent hologram',
    ),

    // HARD/EDGY (5)
    BorderFrame(
      id: 'edgy_skull',
      name: 'Skull',
      category: 'Hard/Edgy',
      assetPath: 'assets/borders/edgy_skull.png',
      description: 'Skull motifs',
    ),
    BorderFrame(
      id: 'edgy_lightning',
      name: 'Lightning',
      category: 'Hard/Edgy',
      assetPath: 'assets/borders/edgy_lightning.png',
      description: 'Electric bolts',
    ),
    BorderFrame(
      id: 'edgy_metal',
      name: 'Brushed Metal',
      category: 'Hard/Edgy',
      assetPath: 'assets/borders/edgy_metal.png',
      description: 'Industrial bolts',
    ),
    BorderFrame(
      id: 'edgy_flame',
      name: 'Flames',
      category: 'Hard/Edgy',
      assetPath: 'assets/borders/edgy_flame.png',
      description: 'Fire border',
    ),
    BorderFrame(
      id: 'edgy_blade',
      name: 'Blade',
      category: 'Hard/Edgy',
      assetPath: 'assets/borders/edgy_blade.png',
      description: 'Sharp edges',
    ),

    // CREATURES (5)
    BorderFrame(
      id: 'creature_blob',
      name: 'Blob Friends',
      category: 'Creatures',
      assetPath: 'assets/borders/creature_blob.png',
      description: 'Cute blob monsters',
    ),
    BorderFrame(
      id: 'creature_plant',
      name: 'Garden Pals',
      category: 'Creatures',
      assetPath: 'assets/borders/creature_plant.png',
      description: 'Plant monsters',
    ),
    BorderFrame(
      id: 'creature_cloud',
      name: 'Sky Friends',
      category: 'Creatures',
      assetPath: 'assets/borders/creature_cloud.png',
      description: 'Cloud creatures',
    ),
    BorderFrame(
      id: 'creature_gem',
      name: 'Crystal Buddies',
      category: 'Creatures',
      assetPath: 'assets/borders/creature_gem.png',
      description: 'Gem monsters',
    ),
    BorderFrame(
      id: 'creature_goo',
      name: 'Slime Squad',
      category: 'Creatures',
      assetPath: 'assets/borders/creature_goo.png',
      description: 'Goo creatures',
    ),

    // CATS (5) - Priority!
    BorderFrame(
      id: 'cat_anime',
      name: 'Anime Cats',
      category: 'Cats',
      assetPath: 'assets/borders/cat_anime.png',
      description: 'Kawaii cat faces',
    ),
    BorderFrame(
      id: 'cat_cyber',
      name: 'Cyber Cats',
      category: 'Cats',
      assetPath: 'assets/borders/cat_cyber.png',
      description: 'Neon cat silhouettes',
    ),
    BorderFrame(
      id: 'cat_punk',
      name: 'Punk Cats',
      category: 'Cats',
      assetPath: 'assets/borders/cat_punk.png',
      description: 'Grunge cats with mohawks',
    ),
    BorderFrame(
      id: 'cat_galaxy',
      name: 'Galaxy Cats',
      category: 'Cats',
      assetPath: 'assets/borders/cat_galaxy.png',
      description: 'Cosmic space cats',
    ),
    BorderFrame(
      id: 'cat_ninja',
      name: 'Ninja Cats',
      category: 'Cats',
      assetPath: 'assets/borders/cat_ninja.png',
      description: 'Stealth ninja cats',
    ),

    // KAWAII (5)
    BorderFrame(
      id: 'kawaii_stars',
      name: 'Stars & Bows',
      category: 'Kawaii',
      assetPath: 'assets/borders/kawaii_stars.png',
      description: 'Pastel stars and hearts',
    ),
    BorderFrame(
      id: 'kawaii_bows',
      name: 'Ribbons',
      category: 'Kawaii',
      assetPath: 'assets/borders/kawaii_bows.png',
      description: 'Delicate bows',
    ),
    BorderFrame(
      id: 'kawaii_hearts',
      name: 'Hearts',
      category: 'Kawaii',
      assetPath: 'assets/borders/kawaii_hearts.png',
      description: 'Decorative hearts',
    ),
    BorderFrame(
      id: 'kawaii_sweets',
      name: 'Sweet Treats',
      category: 'Kawaii',
      assetPath: 'assets/borders/kawaii_sweets.png',
      description: 'Donuts and cupcakes',
    ),
    BorderFrame(
      id: 'kawaii_flowers',
      name: 'Flowers',
      category: 'Kawaii',
      assetPath: 'assets/borders/kawaii_flowers.png',
      description: 'Cherry blossoms',
    ),
  ];

  /// Get borders by category
  static List<BorderFrame> byCategory(String category) {
    return all.where((frame) => frame.category == category).toList();
  }

  /// Get all unique categories
  static List<String> get categories {
    return all.map((frame) => frame.category).toSet().toList();
  }
}
