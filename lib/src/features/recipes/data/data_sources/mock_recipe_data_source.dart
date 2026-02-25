import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe.dart';
import 'package:smart_chef_ai_assistant/src/features/recipes/domain/recipe_step.dart';

class MockRecipeDataSource {
  // Наши 2 базовых рецепта
  final Recipe _carbonara = Recipe(
    id: 'pasta-carbonara',
    title: 'Паста Карбонара',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRig99ofqPihJiVYx8A9BtzgrJnC7rC9LA-lqz8DN4DZEqwaMde5nwP_vuFNydRQbHHsDgQK0QikI0mL1SR2eLYPbqywgi4HoitUo-KYfzDfg&s=10',
    ingredients: [
      'Спагетти - 200г',
      'Гуанчиале - 100г',
      'Яичные желтки - 3 шт.',
      'Пекорино Романо - 50г',
      'Черный перец',
    ],
    steps: [
      RecipeStep(
        title: 'Шаг 1: Подготовка',
        description:
            'Нарежьте гуанчиале кубиками. Натрите сыр Пекорино на мелкой терке. Отделите желтки от белков.',
      ),
      RecipeStep(
        title: 'Шаг 2: Варка пасты',
        description:
            'Отварите спагетти в большом количестве подсоленной воды до состояния "аль денте" (на 1 минуту меньше, чем указано на упаковке).',
      ),
      RecipeStep(
        title: 'Шаг 3: Соус',
        description:
            'В миске смешайте желтки, большую часть тертого сыра и свежемолотый черный перец. Перемешайте до однородной массы.',
      ),
      RecipeStep(
        title: 'Шаг 4: Гуанчиале',
        description:
            'На сухой сковороде обжарьте гуанчиале на среднем огне до хрустящей корочки. Жир должен вытопиться.',
      ),
      RecipeStep(
        title: 'Шаг 5: Сборка',
        description:
            'Слейте воду с пасты, оставив немного. Переложите пасту в сковороду к гуанчиале (сняв с огня!). Быстро добавьте яично-сырную смесь и немного воды от пасты. Интенсивно перемешивайте, пока соус не станет кремовым. Не ставьте на огонь, иначе яйца свернутся!',
      ),
      RecipeStep(
        title: 'Шаг 6: Подача',
        description: 'Немедленно подавайте, посыпав оставшимся сыром и перцем.',
      ),
    ],
  );

  final Recipe _borscht = Recipe(
    id: 'borscht',
    title: 'Борщ',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsStK__Qzn_TTwHC9vfgKyDsZCr7TEVoQmzQ&s',
    ingredients: [
      'Говядина на кости - 500г',
      'Свекла - 2 шт.',
      'Капуста - 300г',
      'Картофель - 3 шт.',
      'Морковь - 1 шт.',
      'Лук - 1 шт.',
      'Томатная паста - 2 ст.л.',
      'Уксус - 1 ст.л.',
      'Чеснок, соль, перец, лавровый лист',
    ],
    steps: [
      RecipeStep(
        title: 'Шаг 1: Бульон',
        description:
            'Залейте мясо водой, доведите до кипения, снимите пену. Варите на медленном огне 1.5-2 часа. Достаньте мясо, отделите от костей и нарежьте.',
      ),
      RecipeStep(
        title: 'Шаг 2: Зажарка',
        description:
            'Натрите свеклу и морковь, нарежьте лук. Обжарьте лук и морковь. Отдельно потушите свеклу с томатной пастой и уксусом (уксус сохранит цвет).',
      ),
      RecipeStep(
        title: 'Шаг 3: Картофель и капуста',
        description:
            'Нарежьте картофель кубиками, капусту нашинкуйте. Добавьте в кипящий бульон картофель, через 10 минут - капусту.',
      ),
      RecipeStep(
        title: 'Шаг 4: Сборка',
        description:
            'Когда картофель и капуста будут почти готовы, добавьте в суп зажарку из лука/моркови и тушеную свеклу. Добавьте нарезанное мясо.',
      ),
      RecipeStep(
        title: 'Шаг 5: Финал',
        description:
            'Добавьте лавровый лист, соль, перец. В самом конце добавьте измельченный чеснок. Дайте борщу настояться под крышкой 20-30 минут.',
      ),
    ],
  );

  final Recipe _caesarSalad = Recipe(
    id: 'caesar-salad',
    title: 'Салат Цезарь',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhk8JvERcNh3Q0g_VxzTsTcSdlBWgDeYlEzA&s',
    ingredients: [
      'Куриное филе - 300г',
      'Листья Ромен - 1 пучок',
      'Пармезан - 50г',
      'Помидоры Черри - 100г',
      'Сухарики',
      'Соус Цезарь',
    ],
    steps: [
      RecipeStep(
        title: 'Шаг 1: Курица',
        description:
            'Нарежьте и обжарьте куриное филе до готовности, нарежьте кубиками.',
      ),
      RecipeStep(
        title: 'Шаг 2: Подготовка овощей',
        description: 'Порвите листья Ромен, разрежьте Черри пополам.',
      ),
      RecipeStep(
        title: 'Шаг 3: Заправка',
        description: 'Смешайте листья Ромен с соусом Цезарь.',
      ),
      RecipeStep(
        title: 'Шаг 4: Сборка',
        description:
            'Сверху выложите курицу, Черри, сухарики и посыпьте Пармезаном.',
      ),
    ],
  );

  final Recipe _pancakes = Recipe(
    id: 'pancakes',
    title: 'Американские Панкейки',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjmPinrqqk9S5dcCeMtcz7oh2DgHeLU8yZ-g&s',
    ingredients: [
      'Мука - 200г',
      'Молоко - 250 мл',
      'Яйцо - 1 шт.',
      'Сахар - 2 ст.л.',
      'Разрыхлитель - 1 ч.л.',
      'Сливочное масло',
    ],
    steps: [
      RecipeStep(
        title: 'Шаг 1: Сухие ингредиенты',
        description: 'Смешайте муку, сахар и разрыхлитель.',
      ),
      RecipeStep(
        title: 'Шаг 2: Мокрые ингредиенты',
        description: 'Взбейте яйцо с молоком и растопленным маслом.',
      ),
      RecipeStep(
        title: 'Шаг 3: Тесто',
        description:
            'Аккуратно соедините сухие и мокрые смеси. Не перемешивайте слишком долго, комочки допустимы.',
      ),
      RecipeStep(
        title: 'Шаг 4: Выпекание',
        description:
            'Выпекайте на сухой, разогретой сковороде по 2-3 минуты с каждой стороны до появления пузырьков.',
      ),
      RecipeStep(
        title: 'Шаг 5: Подача',
        description: 'Подавайте стопкой, полив сиропом или джемом.',
      ),
    ],
  );

  final Recipe _tikkaMasala = Recipe(
    id: 'chicken-tikka-masala',
    title: 'Курица Тикка Масала',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThJzV_a4Xn9jGlFLL6aNyRaKL7S0KlPEOvfg&s',
    ingredients: [
      'Куриное филе - 500г',
      'Натуральный йогурт - 150г',
      'Специи (Гарам Масала, Куркума)',
      'Лук',
      'Томатная паста',
      'Сливки 20%',
    ],
    steps: [
      RecipeStep(
        title: 'Шаг 1: Маринад',
        description:
            'Нарежьте курицу, смешайте с йогуртом и специями. Маринуйте минимум 1 час.',
      ),
      RecipeStep(
        title: 'Шаг 2: Обжарка',
        description: 'Обжарьте курицу до румяной корочки и отложите.',
      ),
      RecipeStep(
        title: 'Шаг 3: Соус',
        description:
            'Обжарьте лук, добавьте томатную пасту и оставшиеся специи.',
      ),
      RecipeStep(
        title: 'Шаг 4: Тушение',
        description:
            'Добавьте сливки, доведите до кипения. Верните курицу и тушите 15 минут.',
      ),
      RecipeStep(
        title: 'Шаг 5: Подача',
        description: 'Подавайте с рисом басмати или лепешками наан.',
      ),
    ],
  );

  late final List<Recipe> _baseRecipes = [
    _carbonara,
    _borscht,
    _caesarSalad,
    _pancakes,
    _tikkaMasala,
  ];

  Future<List<Recipe>> getAllRecipes() async {
    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 300));

    List<Recipe> recipes = [];
    const int repetitionCount = 4; // 5 рецептов * 4 раза = 20

    for (int i = 0; i < repetitionCount; i++) {
      for (int j = 0; j < _baseRecipes.length; j++) {
        final baseRecipe = _baseRecipes[j];
        // Добавляем рецепт с уникальным ID для работы с навигацией и избранным
        recipes.add(baseRecipe.copyWith(id: '${baseRecipe.id}-$i'));
      }
    }

    return recipes;
  }
}
