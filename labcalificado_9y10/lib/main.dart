import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disney+ Peru',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF040714),
        scaffoldBackgroundColor: const Color(0xFF040714),
        fontFamily: 'Roboto',
      ),
      home: const DisneyPlusHome(),
    );
  }
}

class DisneyPlusHome extends StatefulWidget {
  const DisneyPlusHome({Key? key}) : super(key: key);

  @override
  State<DisneyPlusHome> createState() => _DisneyPlusHomeState();
}

class _DisneyPlusHomeState extends State<DisneyPlusHome> {
  final TextEditingController _emailController = TextEditingController();
  bool isPremiumSelected = true;
  
  // Control para el carrusel de imágenes del banner
  final PageController _bannerPageController = PageController();
  int _currentBannerPage = 0;
  Timer? _bannerTimer;
  
  // Control para el carrusel de contenido reciente
  final PageController _contentPageController = PageController(viewportFraction: 0.35);
  Timer? _contentTimer;
  
  // Imágenes rotativas del banner principal - Películas de Disney
  final List<String> _bannerImages = [
    'https://prod-ripcut-delivery.disney-plus.net/v1/variant/disney/7F51FA9F6CBD9F0C9B1394B1CC0A6A842D35A477CF54826C97FD317FF72CC BE/scale?width=1440&aspectRatio=1.78&format=jpeg',
    'https://prod-ripcut-delivery.disney-plus.net/v1/variant/disney/56D2B33C8E1C4F6F3F3C0EFF1F0F3F6B3F3F3F3F/scale?width=1440&aspectRatio=1.78&format=jpeg',
    'https://lumiere-a.akamaihd.net/v1/images/p_encanto_homeent_22359_4892ae1c.jpeg',
    'https://lumiere-a.akamaihd.net/v1/images/p_disney_moana_hero_1_a4e0e627.jpeg',
  ];

  // Imágenes de películas para "Recién agregados" - Posters de Disney
  final List<String> contentImages = [
    'https://lumiere-a.akamaihd.net/v1/images/p_encanto_homeent_22359_4892ae1c.jpeg',
    'https://lumiere-a.akamaihd.net/v1/images/p_disney_moana_hero_1_a4e0e627.jpeg',
    'https://lumiere-a.akamaihd.net/v1/images/p_coco_19736_fd5fa537.jpeg',
    'https://lumiere-a.akamaihd.net/v1/images/p_frozen2_disneyplus_21972_05e0f834.jpeg',
    'https://lumiere-a.akamaihd.net/v1/images/p_ratatouille_19736_0814231f.jpeg',
    'https://lumiere-a.akamaihd.net/v1/images/p_insideout_19751_08481d47.jpeg',
    'https://lumiere-a.akamaihd.net/v1/images/p_lionking2019_19752_3f2c9c8f.jpeg',
    'https://lumiere-a.akamaihd.net/v1/images/p_toystory4_19751_3c174ca5.jpeg',
    'https://lumiere-a.akamaihd.net/v1/images/p_incredibles2_19751_de3b675b.jpeg',
    'https://lumiere-a.akamaihd.net/v1/images/p_blackpanther_19754_4ac13f07.jpeg',
    'https://lumiere-a.akamaihd.net/v1/images/p_avengersendgame_19751_3c9f8f9f.jpeg',
    'https://lumiere-a.akamaihd.net/v1/images/p_starwars_thelastjedi_19752_d18a8d36.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _startBannerAutoPlay();
    _startContentAutoPlay();
  }

  void _startBannerAutoPlay() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentBannerPage < _bannerImages.length - 1) {
        _currentBannerPage++;
      } else {
        _currentBannerPage = 0;
      }
      
      if (_bannerPageController.hasClients) {
        _bannerPageController.animateToPage(
          _currentBannerPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _startContentAutoPlay() {
    _contentTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_contentPageController.hasClients && _contentPageController.page != null) {
        double nextPage = _contentPageController.page! + 1;
        if (nextPage >= contentImages.length) {
          nextPage = 0;
        }
        _contentPageController.animateToPage(
          nextPage.toInt(),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _bannerTimer?.cancel();
    _contentTimer?.cancel();
    _bannerPageController.dispose();
    _contentPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040714),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMainBanner(),
            _buildSubscriptionForm(),
            const SizedBox(height: 40),
            _buildESPNBanner(),
            const SizedBox(height: 40),
            _buildPlanSelector(),
            const SizedBox(height: 30),
            _buildPlansComparison(),
            const SizedBox(height: 40),
            _buildRecentlyAdded(),
            const SizedBox(height: 40),
            _buildWatchAnywhere(),
            const SizedBox(height: 40),
            _buildFAQ(),
            const SizedBox(height: 40),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // BANNER PRINCIPAL CON IMÁGENES ROTATIVAS
  Widget _buildMainBanner() {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: Stack(
          children: [
            // PageView con imágenes rotativas
            Positioned.fill(
              child: PageView.builder(
                controller: _bannerPageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentBannerPage = index;
                  });
                },
                itemCount: _bannerImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        _bannerImages[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: const Color(0xFF1E40AF),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue[900]!, Colors.blue[700]!],
                              ),
                            ),
                          );
                        },
                      ),
                      // Overlay oscuro
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              const Color(0xFF040714).withOpacity(0.8),
                              const Color(0xFF040714),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Contenido sobre el banner
            Positioned.fill(
              child: Column(
                children: [
                  // Botón INICIAR SESIÓN
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'INICIAR SESIÓN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Logo Disney+
                  Image.asset(
                    'assets/images/disney_logo.png',
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'Disney+',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Botón pause
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.pause, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            // Indicadores de página
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _bannerImages.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentBannerPage == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FORMULARIO DE SUSCRIPCIÓN
  Widget _buildSubscriptionForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Series exclusivas, éxitos del\ncine, el deporte de ESPN y más',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Merriweather',
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Ingresa tu correo para comenzar',
            style: TextStyle(color: Colors.grey[400], fontSize: 15),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Correo electrónico',
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
              filled: true,
              fillColor: const Color(0xFF1A1D29),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D9FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 0,
              ),
              child: const Text(
                'SUSCRIBIRME AHORA',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.5),
              children: const [
                TextSpan(text: 'Ahorra desde 30% en '),
                TextSpan(
                  text: 'Disney+ Premium Anual',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                TextSpan(text: '. '),
                TextSpan(
                  text: 'Ver detalles de los planes',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Image.asset(
            'assets/images/tipos_prgramas.png',
            height: 30,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Wrap(
                alignment: WrapAlignment.center,
                spacing: 6,
                children: [
                  _buildBrandText('Disney+'),
                  _buildPlusSign(),
                  _buildBrandText('Pixar'),
                  _buildPlusSign(),
                  _buildBrandText('Marvel'),
                  _buildPlusSign(),
                  _buildBrandText('Star Wars'),
                  _buildPlusSign(),
                  _buildBrandText('Nat Geo'),
                  _buildPlusSign(),
                  _buildBrandText('ESPN'),
                  _buildPlusSign(),
                  _buildBrandText('Hulu'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBrandText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPlusSign() {
    return const Text(
      '+',
      style: TextStyle(color: Colors.white, fontSize: 12),
    );
  }

  // BANNER ESPN
  Widget _buildESPNBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0066CC), Color(0xFF003D7A)],
        ),
      ),
      child: Stack(
        children: [
          // Imagen de fondo deportiva
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://images.unsplash.com/photo-1459865264687-595d652de67e?w=1200&q=80',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.3),
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: const Color(0xFF003D7A));
                },
              ),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF003D7A).withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/ESPN_wordmark.svg/2560px-ESPN_wordmark.svg.png',
                      height: 40,
                      color: Colors.white,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          'ESPN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'EN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Image.asset(
                      'assets/images/disney_logo.png',
                      height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          'Disney+',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Plan Premium',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'El deporte de ESPN y los eventos en vivo que te\napasionan los encontrás en el plan Premium de\nDisney+.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.6,
                    fontFamily: 'Merriweather',
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D9FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'SUSCRIBIRME AHORA',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SELECTOR DE PLANES
  Widget _buildPlanSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text(
            '¿Qué plan vas a elegir?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'Merriweather',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Podrás modificarlo o cancelarlo cuando quieras.',
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1D29),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPremiumSelected = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isPremiumSelected
                            ? const Color(0xFF00D9FF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'PREMIUM',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isPremiumSelected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPremiumSelected = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !isPremiumSelected
                            ? const Color(0xFF00D9FF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'ESTÁNDAR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !isPremiumSelected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'PEN 68,90/mes (final)*',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Plan anual',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'PEN 49,90/mes (final)*',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Plan mensual',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // COMPARACIÓN DE PLANES
  Widget _buildPlansComparison() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildComparisonRow(
            'Plan anual\nDisfruta de 12 meses al precio de 9**',
            'PEN 577,80/año (final)**',
            '-',
          ),
          const Divider(color: Color(0xFF1A1D29), height: 32),
          _buildComparisonRow(
            'Todos los canales de ESPN, torneos y más de 500\neventos exclusivos por mes***',
            '✓',
            '-',
          ),
          const Divider(color: Color(0xFF1A1D29), height: 32),
          _buildComparisonRow(
            'Estrenos de películas, series originales y clásicos de\nDisney, Pixar, Marvel, Star Wars, National Geographic y\nHulu',
            '✓',
            '✓',
          ),
          const Divider(color: Color(0xFF1A1D29), height: 32),
          _buildComparisonRow(
            'Calidad de video hasta 4K UHD/HDR y sonido Dolby\nAtmos*****',
            '✓',
            '-',
          ),
          const Divider(color: Color(0xFF1A1D29), height: 32),
          _buildComparisonRow(
            'Dispositivos para ver en simultáneo',
            '4',
            '2',
          ),
          const Divider(color: Color(0xFF1A1D29), height: 32),
          _buildComparisonRow(
            'Descargas para ver tus favoritos sin conexión ni\ndemoras',
            '✓',
            '✓',
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String feature, String premium, String standard) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            feature,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            premium,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: premium == '✓' ? Colors.white : Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            standard,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: standard == '✓' ? Colors.white : Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // RECIÉN AGREGADOS CON CARRUSEL AUTOMÁTICO - MÁS JUNTOS
  Widget _buildRecentlyAdded() {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 0, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text(
              'Recién agregados',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Merriweather',
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 210,
            child: PageView.builder(
              controller: _contentPageController,
              itemCount: contentImages.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _contentPageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_contentPageController.position.haveDimensions) {
                      value = _contentPageController.page! - index;
                      value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                    }
                    return Center(
                      child: SizedBox(
                        height: Curves.easeInOut.transform(value) * 210,
                        width: 140,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        contentImages[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.movie,
                              color: Colors.white54,
                              size: 50,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // CUANDO Y DONDE QUIERAS
  Widget _buildWatchAnywhere() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Text(
            'Cuando y donde\nquieras',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Merriweather',
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Disfruta tus favoritos en cualquier momento\ny lugar.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Image.asset(
            'assets/images/laptops.png',
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                'https://cnbl-cdn.bamgrid.com/assets/7ecc8bcb60ad77193058d63e321bd21cbac2fc67.png',
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[800],
                    child: const Icon(Icons.devices, color: Colors.white54, size: 80),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // PREGUNTAS FRECUENTES
  Widget _buildFAQ() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preguntas frecuentes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Merriweather',
            ),
          ),
          const SizedBox(height: 20),
          _buildFAQItem('¿Qué incluye Disney+?'),
          const SizedBox(height: 12),
          _buildFAQItem('¿Cómo puedo pagar?'),
          const SizedBox(height: 12),
          _buildFAQItem('¿Dónde puedo ver Disney+?'),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D29),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.add, color: Colors.white, size: 24),
        ],
      ),
    );
  }

  // FOOTER
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: const Color(0xFF0E0E10),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.language, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Español', style: TextStyle(color: Colors.white)),
              Icon(Icons.keyboard_arrow_down, color: Colors.white),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Más información',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildFooterLink('Términos de uso'),
          _buildFooterLink('Política de privacidad'),
          _buildFooterLink('Publicidad personalizada'),
          _buildFooterLink('Acuerdo de Suscripción'),
          const SizedBox(height: 24),
          _buildFooterSection('Ayuda'),
          _buildFooterSection('Marcas'),
          _buildFooterSection('Colecciones'),
          const SizedBox(height: 24),
          Image.asset(
            'assets/images/redes_sociales.png',
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.close, color: Colors.grey, size: 28),
                  SizedBox(width: 20),
                  Icon(Icons.facebook, color: Colors.grey, size: 28),
                  SizedBox(width: 20),
                  Icon(Icons.camera_alt, color: Colors.grey, size: 28),
                  SizedBox(width: 20),
                  Icon(Icons.music_note, color: Colors.grey, size: 28),
                  SizedBox(width: 20),
                  Icon(Icons.play_circle_outline, color: Colors.grey, size: 28),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Image.asset(
            'assets/images/disney_logo.png',
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                'Disney+',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            '© 2025 Disney y su familia de compañías afiliadas. Todos los\nderechos reservados.',
            style: TextStyle(color: Colors.grey[600], fontSize: 10),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'La programación del contenido deportivo difiere según el plan. Disney+\nrequiere una suscripción y ser mayor de 18 años. Contenidos sujetos a\ndisponibilidad.',
            style: TextStyle(color: Colors.grey[600], fontSize: 10),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'El servicio Disney+ es comercializado por Disney DTC LATAM, Inc., 2400 W\nAlameda Ave., Burbank CA 91521 y Tax ID 75-3016153.',
            style: TextStyle(color: Colors.grey[700], fontSize: 9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[400], fontSize: 12),
      ),
    );
  }

  Widget _buildFooterSection(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white, size: 20),
        ],
      ),
    );
  }
}