import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/core/constants/app_constants.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/core/services/gemini_ai_service.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/ai_insight/data/datasources/ai_local_datasource.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/ai_insight/data/repositories/ai_insight_repository_impl.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/ai_insight/domain/usecases/delete_ai_insight_usecase.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/ai_insight/domain/usecases/generate_ai_insight_usecase.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/ai_insight/domain/usecases/get_saved_insights_usecase.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/ai_insight/presentation/viewmodels/ai_insight_viewmodel.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/auth/domain/entities/user.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/auth/domain/usecases/login_user.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/auth/domain/usecases/logout_user.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/auth/domain/usecases/register_user.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/history/data/datasources/history_local_datasource.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/history/data/repositories/history_repository_impl.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/history/domain/usecases/get_history_timeline.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/history/presentation/viewmodels/history_viewmodel.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/shops/data/datasources/shop_local_datasource.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/shops/data/repositories/shop_repository_impl.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/shops/domain/entities/shop.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/shops/domain/usecases/add_shop_usecase.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/shops/domain/usecases/delete_shop_usecase.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/shops/domain/usecases/get_products_usecase.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/shops/domain/usecases/get_shops_usecase.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/shops/domain/usecases/update_shop_usecase.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/features/shops/presentation/viewmodels/shop_viewmodel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Clean Architecture - Auth Feature Tests', () {
    late SharedPreferences prefs;
    late AuthViewModel authViewModel;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      final localDataSource = AuthLocalDataSourceImpl(prefs);
      final repo = AuthRepositoryImpl(localDataSource);

      authViewModel = AuthViewModel(
        loginUser: LoginUser(repo),
        registerUser: RegisterUser(repo),
        getCurrentUser: GetCurrentUser(repo),
        logoutUser: LogoutUser(repo),
      );
    });

    test('Default seed users are present and can login', () async {
      final success = await authViewModel.login('admin@dinoyo.id', 'admin123');
      expect(success, isTrue);
      expect(authViewModel.currentUser, isNotNull);
      expect(authViewModel.currentUser!.role, UserRole.admin);
      expect(authViewModel.currentUser!.name, 'Admin Paguyuban');
    });

    test('Can register a new visitor user and login', () async {
      final registered = await authViewModel.register(
        name: 'Budi Santoso',
        email: 'budi@gmail.com',
        password: 'password123',
        role: UserRole.visitor,
        phone: '081298765432',
      );
      expect(registered, isTrue);
      expect(authViewModel.currentUser!.email, 'budi@gmail.com');
      expect(authViewModel.currentUser!.role, UserRole.visitor);

      // Logout and re-login
      await authViewModel.logout();
      expect(authViewModel.currentUser, isNull);

      final loginOk = await authViewModel.login('budi@gmail.com', 'password123');
      expect(loginOk, isTrue);
      expect(authViewModel.currentUser!.name, 'Budi Santoso');
    });
  });

  group('Clean Architecture - Shops & Products Feature Tests', () {
    late SharedPreferences prefs;
    late ShopViewModel shopViewModel;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      final localDataSource = ShopLocalDataSourceImpl(prefs);
      final repo = ShopRepositoryImpl(localDataSource);

      shopViewModel = ShopViewModel(
        getShops: GetShops(repo),
        addShopUseCase: AddShop(repo),
        updateShopUseCase: UpdateShop(repo),
        deleteShopUseCase: DeleteShop(repo),
        getProducts: GetProducts(repo),
      );
    });

    test('Initial shops and products are loaded with real photo assets', () {
      final shops = shopViewModel.allShops;
      expect(shops.length, greaterThanOrEqualTo(5));

      final products = shopViewModel.allProducts;
      expect(products.length, greaterThanOrEqualTo(6));
      expect(products.first.imageAsset, contains('assets/images/'));
    });

    test('Can add a new shop and filter by search query', () {
      const newShop = Shop(
        id: 'shop_test_1',
        name: 'Keramik Dinoyo Berkah',
        specialty: 'Semi-Porselen',
        address: 'Jl. MT Haryono IX No.99',
        hours: '08.00 - 17.00 WIB',
        workshop: WorkshopStatus.tersedia,
        categoryKeys: ['Semi-Porselen'],
        about: 'Toko keramik baru di Dinoyo',
      );

      shopViewModel.addShop(newShop);
      expect(shopViewModel.allShops.any((s) => s.id == 'shop_test_1'), isTrue);

      shopViewModel.setSearchQuery('Berkah');
      expect(shopViewModel.filteredShops.length, 1);
      expect(shopViewModel.filteredShops.first.name, 'Keramik Dinoyo Berkah');
    });
  });

  group('Clean Architecture - History Feature Tests', () {
    test('History timeline contains all eras including 8th century Kanjuruhan & 1957', () {
      final localDataSource = HistoryLocalDataSourceImpl();
      final repo = HistoryRepositoryImpl(localDataSource);
      final vm = HistoryViewModel(getHistoryTimeline: GetHistoryTimeline(repo));

      final eras = vm.eras;
      expect(eras.length, greaterThanOrEqualTo(7));
      expect(eras.any((e) => e.chip.contains('Abad ke-8')), isTrue);
      expect(eras.any((e) => e.chip == '1957'), isTrue);
      expect(eras.any((e) => e.title.contains('Motif Miring')), isTrue);
    });
  });

  group('Clean Architecture - AI Insight Feature Tests', () {
    late SharedPreferences prefs;
    late AiInsightViewModel aiViewModel;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      final localDataSource = AiLocalDataSourceImpl(prefs);
      final geminiService = GeminiAiService();
      final repo = AiInsightRepositoryImpl(
        geminiService: geminiService,
        localDataSource: localDataSource,
      );

      aiViewModel = AiInsightViewModel(
        generateAiInsight: GenerateAiInsight(repo),
        getSavedInsights: GetSavedInsights(repo),
        deleteAiInsight: DeleteAiInsight(repo),
      );
    });

    test('Gemini prompt must contain Role, Constraint, and Output Schema', () {
      final geminiService = GeminiAiService();
      final prompt = geminiService.buildStructuredPrompt('Rekomendasi souvenir pernikahan');

      expect(prompt, contains('[ROLE]'));
      expect(prompt, contains(AppConstants.geminiRole));
      expect(prompt, contains('[CONSTRAINT]'));
      expect(prompt, contains(AppConstants.geminiConstraint));
      expect(prompt, contains('[OUTPUT SCHEMA]'));
      expect(prompt, contains('"ceramic_recommendation"'));
      expect(prompt, contains('"cultural_significance"'));
    });

    test('Generates validated JSON insight and stores it locally', () async {
      final ok = await aiViewModel.askCurator('Rekomendasi souvenir pernikahan 300 tamu');
      expect(ok, isTrue);
      expect(aiViewModel.currentInsight, isNotNull);

      final insight = aiViewModel.currentInsight!;
      expect(insight.title.isNotEmpty, isTrue);
      expect(insight.category.isNotEmpty, isTrue);
      expect(insight.ceramicRecommendation.isNotEmpty, isTrue);
      expect(insight.culturalSignificance.isNotEmpty, isTrue);
      expect(insight.rawJson.isNotEmpty, isTrue);

      // Verify stored in history
      expect(aiViewModel.savedInsights.length, 1);
      expect(aiViewModel.savedInsights.first.id, insight.id);
    });
  });
}
