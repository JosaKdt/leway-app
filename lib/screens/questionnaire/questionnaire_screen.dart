import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isFrench = true;
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;

  // Réponses : clé = index question, valeur = score (1-5)
  final Map<int, int> _reponses = {};

  // 28 questions RIASEC mockées
  // Format : {fr, en, type} — type = R/I/A/S/E/C
  final List<Map<String, String>> _questions = [
    // R — Réaliste
    {
      'fr': 'J\'aime travailler avec des outils et des machines',
      'en': 'I enjoy working with tools and machines',
      'type': 'R'
    },
    {
      'fr': 'J\'aime les activités physiques et manuelles',
      'en': 'I enjoy physical and manual activities',
      'type': 'R'
    },
    {
      'fr': 'Je préfère les tâches concrètes aux tâches abstraites',
      'en': 'I prefer concrete tasks over abstract ones',
      'type': 'R'
    },
    {
      'fr': 'J\'aime réparer ou construire des objets',
      'en': 'I like repairing or building things',
      'type': 'R'
    },
    // I — Investigateur
    {
      'fr': 'J\'aime résoudre des problèmes complexes',
      'en': 'I enjoy solving complex problems',
      'type': 'I'
    },
    {
      'fr': 'Je suis curieux et j\'aime comprendre comment les choses fonctionnent',
      'en': 'I am curious and like to understand how things work',
      'type': 'I'
    },
    {
      'fr': 'J\'aime faire des recherches et analyser des données',
      'en': 'I enjoy doing research and analyzing data',
      'type': 'I'
    },
    {
      'fr': 'Les sciences et les mathématiques m\'intéressent beaucoup',
      'en': 'Science and mathematics interest me a lot',
      'type': 'I'
    },
    // A — Artistique
    {
      'fr': 'J\'aime créer des choses originales',
      'en': 'I enjoy creating original things',
      'type': 'A'
    },
    {
      'fr': 'J\'aime exprimer mes idées à travers l\'art ou l\'écriture',
      'en': 'I like expressing my ideas through art or writing',
      'type': 'A'
    },
    {
      'fr': 'Je suis attiré par la musique, le dessin ou le théâtre',
      'en': 'I am drawn to music, drawing, or theater',
      'type': 'A'
    },
    {
      'fr': 'J\'aime imaginer et inventer de nouvelles idées',
      'en': 'I enjoy imagining and inventing new ideas',
      'type': 'A'
    },
    // S — Social
    {
      'fr': 'J\'aime aider les autres et travailler en équipe',
      'en': 'I enjoy helping others and working in teams',
      'type': 'S'
    },
    {
      'fr': 'J\'aime enseigner ou expliquer des choses aux autres',
      'en': 'I enjoy teaching or explaining things to others',
      'type': 'S'
    },
    {
      'fr': 'Je suis à l\'aise pour communiquer avec des personnes différentes',
      'en': 'I am comfortable communicating with different people',
      'type': 'S'
    },
    {
      'fr': 'Le bien-être des autres est important pour moi',
      'en': 'The well-being of others is important to me',
      'type': 'S'
    },
    // E — Entrepreneur
    {
      'fr': 'J\'aime prendre des initiatives et diriger des projets',
      'en': 'I enjoy taking initiatives and leading projects',
      'type': 'E'
    },
    {
      'fr': 'Je suis à l\'aise pour convaincre et persuader les autres',
      'en': 'I am comfortable persuading and convincing others',
      'type': 'E'
    },
    {
      'fr': 'J\'aime les défis et prendre des risques calculés',
      'en': 'I enjoy challenges and taking calculated risks',
      'type': 'E'
    },
    {
      'fr': 'J\'ai envie de créer ma propre entreprise un jour',
      'en': 'I want to start my own business someday',
      'type': 'E'
    },
    // C — Conventionnel
    {
      'fr': 'J\'aime organiser, classer et mettre de l\'ordre',
      'en': 'I enjoy organizing, filing, and keeping things in order',
      'type': 'C'
    },
    {
      'fr': 'Je suis à l\'aise avec les règles et les procédures',
      'en': 'I am comfortable with rules and procedures',
      'type': 'C'
    },
    {
      'fr': 'J\'aime les tâches qui demandent de la précision et de l\'attention',
      'en': 'I enjoy tasks that require precision and attention',
      'type': 'C'
    },
    {
      'fr': 'Je préfère un environnement de travail structuré et stable',
      'en': 'I prefer a structured and stable work environment',
      'type': 'C'
    },
    // Questions mixtes
    {
      'fr': 'Je me sens à l\'aise dans les situations nouvelles et imprévues',
      'en': 'I feel comfortable in new and unexpected situations',
      'type': 'A'
    },
    {
      'fr': 'J\'aime analyser les problèmes avant d\'agir',
      'en': 'I like analyzing problems before acting',
      'type': 'I'
    },
    {
      'fr': 'Je préfère travailler seul plutôt qu\'en groupe',
      'en': 'I prefer working alone rather than in a group',
      'type': 'R'
    },
    {
      'fr': 'J\'ai facilement de l\'influence sur les décisions du groupe',
      'en': 'I easily influence group decisions',
      'type': 'E'
    },
  ];

  final List<Map<String, dynamic>> _choix = [
    {'label_fr': 'Tout à fait d\'accord', 'label_en': 'Strongly agree', 'score': 5},
    {'label_fr': 'D\'accord', 'label_en': 'Agree', 'score': 4},
    {'label_fr': 'Neutre', 'label_en': 'Neutral', 'score': 3},
    {'label_fr': 'Pas d\'accord', 'label_en': 'Disagree', 'score': 2},
    {'label_fr': 'Pas du tout d\'accord', 'label_en': 'Strongly disagree', 'score': 1},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _selectAnswer(int score) async {
    setState(() => _reponses[_currentIndex] = score);

    await Future.delayed(const Duration(milliseconds: 300));

    if (_currentIndex < _questions.length - 1) {
      _animController.reset();
      setState(() => _currentIndex++);
      _animController.forward();
    } else {
      // Toutes les questions répondues → aller au rapport
      Navigator.pushReplacementNamed(context, '/rapport');
    }
  }

  void _prevQuestion() {
    if (_currentIndex > 0) {
      _animController.reset();
      setState(() => _currentIndex--);
      _animController.forward();
    }
  }

  double get _progress => (_currentIndex + 1) / _questions.length;

  String get _typeLabel {
    final type = _questions[_currentIndex]['type']!;
    const labels = {
      'R': 'Réaliste',
      'I': 'Investigateur',
      'A': 'Artistique',
      'S': 'Social',
      'E': 'Entrepreneur',
      'C': 'Conventionnel',
    };
    const labelsEn = {
      'R': 'Realistic',
      'I': 'Investigative',
      'A': 'Artistic',
      'S': 'Social',
      'E': 'Enterprising',
      'C': 'Conventional',
    };
    return _isFrench ? labels[type]! : labelsEn[type]!;
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];
    final selectedScore = _reponses[_currentIndex];

    return Scaffold(
      backgroundColor: LeWayColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LeWayColors.headerGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _prevQuestion,
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: _currentIndex > 0
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          size: 20,
                        ),
                      ),
                      Text(
                        _isFrench
                            ? 'Question ${_currentIndex + 1} sur ${_questions.length}'
                            : 'Question ${_currentIndex + 1} of ${_questions.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _isFrench = !_isFrench),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Text('FR',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: _isFrench
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.5))),
                              const SizedBox(width: 4),
                              Container(
                                  width: 1,
                                  height: 10,
                                  color: Colors.white.withOpacity(0.4)),
                              const SizedBox(width: 4),
                              Text('EN',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: !_isFrench
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.5))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Barre de progression
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.white.withOpacity(0.25),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Badge type RIASEC
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${question['type']} — $_typeLabel',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '${(_progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Question
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isFrench ? question['fr']! : question['en']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: LeWayColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Choix de réponse
                      ..._choix.map((choix) {
                        final isSelected = selectedScore == choix['score'];
                        return GestureDetector(
                          onTap: () => _selectAnswer(choix['score'] as int),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? LeWayColors.primary
                                  : LeWayColors.primaryLight,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? LeWayColors.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.check_circle_rounded
                                      : Icons.circle_outlined,
                                  color: isSelected
                                      ? Colors.white
                                      : LeWayColors.primary,
                                  size: 22,
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  _isFrench
                                      ? choix['label_fr']
                                      : choix['label_en'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : LeWayColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}