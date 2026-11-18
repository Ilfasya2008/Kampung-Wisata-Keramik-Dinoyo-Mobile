import 'package:shared_preferences/shared_preferences.dart';
import '../../features/ai_insight/data/datasources/ai_local_datasource.dart';
import '../../features/ai_insight/data/repositories/ai_insight_repository_impl.dart';
import '../../features/ai_insight/domain/repositories/ai_insight_repository.dart';
import '../../features/ai_insight/domain/usecases/delete_ai_insight_usecase.dart';
import '../../features/ai_insight/domain/usecases/generate_ai_insight_usecase.dart';
import '../../features/ai_insight/domain/usecases/get_saved_insights_usecase.dart';
import '../../features/ai_insight/presentation/viewmodels/ai_insight_viewmodel.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/auth/domain/usecases/logout_user.dart';
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../features/history/data/datasources/history_local_datasource.dart';
import '../../features/history/data/repositories/history_repository_impl.dart';
import '../../features/history/domain/repositories/history_repository.dart';
import '../../features/history/domain/usecases/get_history_timeline.dart';
import '../../features/history/presentation/viewmodels/history_viewmodel.dart';
import '../../features/shops/data/datasources/shop_local_datasource.dart';
import '../../features/shops/data/repositories/shop_repository_impl.dart';
import '../../features/shops/domain/repositories/shop_repository.dart';
import '../../features/shops/domain/usecases/add_shop_usecase.dart';
import '../../features/shops/domain/usecases/delete_shop_usecase.dart';
import '../../features/shops/domain/usecases/get_products_usecase.dart';
import '../../features/shops/domain/usecases/get_shops_usecase.dart';
import '../../features/shops/domain/usecases/update_shop_usecase.dart';
import '../../features/shops/presentation/viewmodels/shop_viewmodel.dart';
import '../services/gemini_ai_service.dart';
import '../services/notification_service.dart';

class InjectionContainer {
  static late final SharedPreferences prefs;
  static late final NotificationService notificationService;

  // ViewModels
  static late final AuthViewModel authViewModel;
  static late final ShopViewModel shopViewModel;
  static late final HistoryViewModel historyViewModel;
  static late final AiInsightViewModel aiViewModel;

  static Future<void> init() async {
    // 1. External & Platform Services
    prefs = await SharedPreferences.getInstance();
    notificationService = NotificationService(prefs);
    await notificationService.initialize();

    // 2. Data Sources
    final authLocalDataSource = AuthLocalDataSourceImpl(prefs);
    final shopLocalDataSource = ShopLocalDataSourceImpl(prefs);
    final historyLocalDataSource = HistoryLocalDataSourceImpl();
    final aiLocalDataSource = AiLocalDataSourceImpl(prefs);
    final geminiService = GeminiAiService();

    // 3. Repositories
    final AuthRepository authRepository = AuthRepositoryImpl(authLocalDataSource);
    final ShopRepository shopRepository = ShopRepositoryImpl(shopLocalDataSource);
    final HistoryRepository historyRepository = HistoryRepositoryImpl(historyLocalDataSource);
    final AiInsightRepository aiRepository = AiInsightRepositoryImpl(
      geminiService: geminiService,
      localDataSource: aiLocalDataSource,
    );

    // 4. Use Cases
    // Auth
    final loginUser = LoginUser(authRepository);
    final registerUser = RegisterUser(authRepository);
    final getCurrentUser = GetCurrentUser(authRepository);
    final logoutUser = LogoutUser(authRepository);

    // Shops
    final getShops = GetShops(shopRepository);
    final addShop = AddShop(shopRepository);
    final updateShop = UpdateShop(shopRepository);
    final deleteShop = DeleteShop(shopRepository);
    final getProducts = GetProducts(shopRepository);

    // History
    final getHistoryTimeline = GetHistoryTimeline(historyRepository);

    // AI Insight
    final generateAiInsight = GenerateAiInsight(aiRepository);
    final getSavedInsights = GetSavedInsights(aiRepository);
    final deleteAiInsight = DeleteAiInsight(aiRepository);

    // 5. ViewModels
    authViewModel = AuthViewModel(
      loginUser: loginUser,
      registerUser: registerUser,
      getCurrentUser: getCurrentUser,
      logoutUser: logoutUser,
    );

    shopViewModel = ShopViewModel(
      getShops: getShops,
      addShopUseCase: addShop,
      updateShopUseCase: updateShop,
      deleteShopUseCase: deleteShop,
      getProducts: getProducts,
    );

    historyViewModel = HistoryViewModel(
      getHistoryTimeline: getHistoryTimeline,
    );

    aiViewModel = AiInsightViewModel(
      generateAiInsight: generateAiInsight,
      getSavedInsights: getSavedInsights,
      deleteAiInsight: deleteAiInsight,
    );
  }
}
