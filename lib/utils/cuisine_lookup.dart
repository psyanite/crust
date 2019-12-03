import 'dart:collection';

class CuisineLookup {
  static const Asian = [11, 12, 13, 15, 17, 19, 20, 26, 26, 35, 41, 59, 78];
  static const AsianFusion = [35];

  static const Thai = [19];
  static const Singaporean = [54];
  static const Malaysian = [27];

  static const Vietnamese = [17, 36];
  static const Pho = [36];
  static const Taiwanese = [41];
  static const Indonesian = [59];

  static const Korean = [15, 28];
  static const KoreanBbq = [28];

  static const Chinese = [9, 12, 13, 22, 25, 26, 40, 30, 9, 13, 41];
  static const Cantonese = [9, 13];
  static const Sichuan = [30];
  static const YumCha = [9];
  static const Malatang = [40];
  static const Shanghai = [26];
  static const HotPot = [22];
  static const Dumplings = [25];

  static const Japanese = [20, 21, 29, 37, 49, 85];
  static const Teppanyaki = [85];
  static const Sushi = [29];
  static const JapaneseBbq = [49];
  static const Ramen = [21];
  static const Teriyaki = [37];

  static const Mexican = [136, 73];
  static const TexMex = [136];

  static const ModernAustralian = [2];
  static const Australian = [57, 2];

  static const MiddleEastern = [91, 95];
  static const Mediterranean = [103];

  static const Spanish = [87, 38];
  static const Tapas = [38];

  static const Indian = [60, 97, 98];
  static const NorthIndian = [97];
  static const SouthIndian = [98];

  static const Nepalese = [71];
  static const Italian = [3];
  static const Creole = [137];
  static const Israeli = [132];
  static const Belgian = [110];
  static const Argentine = [119];
  static const Peruvian = [125];
  static const Venezuelan = [135];
  static const Burmese = [82];
  static const Mongolian = [96];
  static const Danish = [134];
  static const Uruguayan = [139];
  static const Cuban = [145];
  static const Basque = [142];
  static const Czech = [144];
  static const Caribbean = [67];
  static const Egyptian = [127];
  static const Iranian = [123];
  static const Tibetan = [83];
  static const Hungarian = [111];
  static const Polish = [117];
  static const Swedish = [115];
  static const International = [69];
  static const Bangladeshi = [70];
  static const Irish = [124];
  static const Laotian = [48];
  static const Uyghur = [43];
  static const African = [66];
  static const Oriental = [44];
  static const Cambodian = [77];
  static const Austrian = [94];
  static const Hawaiian = [84];
  static const Colombian = [130];
  static const LatinAmerican = [92];
  static const Moroccan = [108];
  static const Ethiopian = [126];
  static const Iraqi = [140];
  static const American = [74];
  static const French = [5];
  static const Pakistani = [61];
  static const Afghan = [88];
  static const German = [107];
  static const Turkish = [104];
  static const Filipino = [78];
  static const European = [81, 118, 122];
  static const SriLankan = [68];
  static const British = [133];
  static const Arabian = [109];
  static const Brazilian = [89];
  static const Portuguese = [93];
  static const Greek = [99];

  static const Coffee = [24, 1, 8, 23];
  static const Brunch = [24, 1, 8, 23, 4];

  static const FastFood = [72, 75, 6, 76, 16];
  static const FriedChicken = [16];
  static const Pizza = [6];
  static const Burger = [75];
  static const FishNChips = [76];

  static const HealthyFood = [52, 33, 18, 32];
  static const Vegetarian = [33, 32, 18];
  static const Salad = [18];
  static const Vegan = [32];

  static const CharcoalChicken = [90];
  static const Chicken = [16, 90];
  static const Kebab = [116];
  static const Lebanese = [106, 116];
  static const Bbq = [39];
  static const Steak = [53];
  static const Grill = [34];

  static const Sweets = [138, 42, 62, 63, 129, 79, 58, 114];
  static const FrozenYogurt = [138];
  static const BubbleTea = [42];
  static const IceCream = [63];
  static const Desserts = [62, 79, 63, 114, 138];
  static const Pastry = [129];
  static const Patisserie = [79];
  static const Bakery = [58];
  static const Crepes = [114];

  static const Seafood = [10];
  static const Sandwich = [46];
  static const PubFood = [45, 31];
  static const Juice = [47];
  static const Fusion = [14];
  static const StreetFood = [65];
  static const Deli = [105];
  static const Tea = [51];
  static const Poke = [55];
  static const MeatPie = [113];
  static const Contemporary = [56];
  static const Falafel = [95];
  static const SoulFood = [120];
  static const Roast = [128];

  static const All = const {
    'asian': Asian,
    'asianfusion': AsianFusion,
    'thai': Thai,
    'singa': Singaporean,
    'singaporean': Singaporean,
    'malay': Malaysian,
    'malaysian': Malaysian,
    'viet': Vietnamese,
    'vietnamese': Vietnamese,
    'pho': Pho,
    'taiwan': Taiwanese,
    'taiwanese': Taiwanese,
    'indo': Indonesian,
    'kor': Korean,
    'korean': Korean,
    'kbbq': KoreanBbq,
    'koreanbarbeque': KoreanBbq,
    'chinese': Chinese,
    'canto': Cantonese,
    'cantonese': Cantonese,
    'sichuan': Sichuan,
    'yumcha': YumCha,
    'mala': Malatang,
    'malatang': Malatang,
    'shanghai': Shanghai,
    'hotpot': HotPot,
    'dumplings': Dumplings,
    'japan': Japanese,
    'teppanyaki': Teppanyaki,
    'sushi': Sushi,
    'japanesebbq': JapaneseBbq,
    'jbbq': JapaneseBbq,
    'jbarbeque': JapaneseBbq,
    'japanesebarbeque': JapaneseBbq,
    'ramen': Ramen,
    'teriyaki': Teriyaki,
    'mexican': Mexican,
    'texmex': TexMex,
    'modernaustralian': ModernAustralian,
    'aus': Australian,
    'australian': Australian,
    'middleeast': MiddleEastern,
    'middleeastern': MiddleEastern,
    'mediterranean': Mediterranean,
    'spanish': Spanish,
    'tapas': Tapas,
    'indian': Indian,
    'northindian': NorthIndian,
    'northernindian': NorthIndian,
    'southernindian': SouthIndian,
    'nepalese': Nepalese,
    'italian': Italian,
    'creole': Creole,
    'israeli': Israeli,
    'argentine': Argentine,
    'peruvian': Peruvian,
    'venezuelan': Venezuelan,
    'burmese': Burmese,
    'mongolian': Mongolian,
    'danish': Danish,
    'uruguayan': Uruguayan,
    'cuban': Cuban,
    'basque': Basque,
    'czech': Czech,
    'caribbean': Caribbean,
    'egyptian': Egyptian,
    'tibetan': Tibetan,
    'iran': Iranian,
    'iranian': Iranian,
    'hungarian': Hungarian,
    'polish': Polish,
    'swedish': Swedish,
    'international': International,
    'bangladeshi': Bangladeshi,
    'irish': Irish,
    'laotian': Laotian,
    'uyghur': Uyghur,
    'african': African,
    'oriental': Oriental,
    'cambodian': Cambodian,
    'austrian': Austrian,
    'hawaiian': Hawaiian,
    'colombian': Colombian,
    'latinamerican': LatinAmerican,
    'moroccan': Moroccan,
    'ethiopian': Ethiopian,
    'iraqi': Iraqi,
    'american': American,
    'french': French,
    'pakistani': Pakistani,
    'afghan': Afghan,
    'german': German,
    'turkish': Turkish,
    'fili': Filipino,
    'filipino': Filipino,
    'europe': European,
    'european': European,
    'sri': SriLankan,
    'srilankan': SriLankan,
    'british': British,
    'brazil': Brazilian,
    'brazilian': Brazilian,
    'portugal': Portuguese,
    'portuguese': Portuguese,
    'greek': Greek,
    'coffee': Coffee,
    'cafe': Coffee,
    'brunch': Brunch,
    'breakfast': Brunch,
    'fastfood': FastFood,
    'friedchicken': FriedChicken,
    'chicken': Chicken,
    'burger': Burger,
    'fishandchips': FishNChips,
    'fishchips': FishNChips,
    'fishnchips': FishNChips,
    'healthy': HealthyFood,
    'healthyfood': HealthyFood,
    'veg': Vegetarian,
    'vegetarian': Vegetarian,
    'salad': Salad,
    'charcoalchicken': CharcoalChicken,
    'kebab': Kebab,
    'lebanese': Lebanese,
    'bbq': Bbq,
    'barbe': Bbq,
    'barbeque': Bbq,
    'steak': Steak,
    'grill': Grill,
    'sweet': Sweets,
    'sweets': Sweets,
    'froyo': FrozenYogurt,
    'frozenyogurt': FrozenYogurt,
    'boba': BubbleTea,
    'bubbletea': BubbleTea,
    'icecream': IceCream,
    'softserve': IceCream,
    'dessert': Desserts,
    'desserts': Desserts,
    'pastry': Pastry,
    'pastries': Pastry,
    'cake': Patisserie,
    'patisserie': Patisserie,
    'bread': Bakery,
    'bake': Bakery,
    'bakery': Bakery,
    'crepe': Crepes,
    'sea': Seafood,
    'seafood': Seafood,
    'sandwich': Sandwich,
    'sandwiches': Sandwich,
    'pub': PubFood,
    'pubfood': PubFood,
    'bar': PubFood,
    'barfood': PubFood,
    'juice': Juice,
    'juices': Juice,
    'fusion': Fusion,
    'street': StreetFood,
    'deli': Deli,
    'tea': Tea,
    'poke': Poke,
    'pokebowl': Poke,
    'meatpie': MeatPie,
    'contemp': Contemporary,
    'contemporary': Contemporary,
    'falaf': Falafel,
    'falafel': Falafel,
    'soul': SoulFood,
    'soulfood': SoulFood,
    'roast': Roast,
  };

  static var all = HashMap<String, Set<int>>.from(All.map((k, v) => MapEntry<String, Set<int>>(k, v.toSet())));
}
