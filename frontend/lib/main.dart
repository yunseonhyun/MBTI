import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/common/env_config.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/screens/history/result_detail_screen.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/login/login_screen.dart';
import 'package:frontend/screens/map/map_screen.dart';
import 'package:frontend/screens/result/result_screen.dart';
import 'package:frontend/screens/signup/signup_screen.dart';
import 'package:frontend/screens/test/test_screen.dart';
import 'package:frontend/screens/types/mbti_types_screen.dart';
import 'package:frontend/services/network_service.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';

import 'models/result_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경별 .env 파일 로드
  // 개발 : .env.development
  // 배포 : .env.production
  // 로컬 : .env.local
  // .env.load(파일이름 : "프로젝트에 존재하는 파일이름")
  await dotenv.load(fileName: ".env.development");

  // 개발 중 상황 확인을 위해 환경 정보 출력
  if (EnvConfig.isDevelopment) EnvConfig.printEnvIndo();

  /*
  자료형 ? = 공간 내부가 텅텅 비어있는데, undefined 호출하여 에러를 발생하는 것이 아니라
      null = 비어있음 상태 처리로 에러 발생시키지 않는 안전타입
      ex) String? 변경가능한 데이터를 보관할 수 있는 공간 명칭;

  공간명칭! = NULL 단어 연산자 이 공간은 절대로 null 아님을 보장하는 표기
      개발자가 null이 아니라고 강제 선언
      위험한 연산자이지만 현재는 사용할 것
      // null이면 빈 문자열 반환하는 방법이 있어요
      static String get kakoMapKey => dotenv.env['KAKAO_MAP_KEY'] ?? '';

      빈값이나 강제 대체값 처리 보다는 가져와야하는 키를 무사히 불러올 수 있도록 로직 구성

      ?? null이면 기본값     name ?? '기번프로필이미지.png'
      ?. null이면 null 반환 name?.length 이름이 비어있으면 null
   */

  AuthRepository.initialize(appKey: dotenv.env['KAKAO_MAP_KEY']!);

  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),

    GoRoute(path: '/map', builder: (context, state) => const MapScreen()),

    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    // 검사화면
    GoRoute(
      path: '/test',
      builder: (context, state) {
        final userName = state.extra as String; // 잠시 사용할 이름인데 문자열임

        /*
            생성된 객체를 사용할 수는 있으나, 매개변수는 존재하지 않은 상태
            단순히 화면만 보여주는 형태
            const TestScreen({super.key});
             */
        return TestScreen(userName: userName);
      },
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) {
        // final data = state.extra as Map<String, dynamic>;
        final result = state.extra as Result;

        /*
            생성된 객체를 사용할 수는 있으나, 매개변수는 존재하지 않은 상태
            단순히 화면만 보여주는 형태
            const TestScreen({super.key});
             */
        /* return ResultScreen(
                userName: data['userName']!,
            resultType: data['resultType']!,
            eScore: data['eScore']!,
            iScore: data['iScore']!,
            sScore: data['sScore']!,
            nScore: data['nScore']!,
            tScore: data['tScore']!,
            fScore: data['fScore']!,
            jScore: data['jScore']!,
            pScore: data['pScore']!
            );
            */
        return ResultScreen(result: result);
      },
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) {
        final userName = state.extra as String;

        /*
            생성된 객체를 사용할 수는 있으나, 매개변수는 존재하지 않은 상태
            단순히 화면만 보여주는 형태
            const TestScreen({super.key});
             */
        // return ResultDetailScreen(userName:state.extra as String);
        //                       required   final userName
        return ResultDetailScreen(userName: userName);
      },
    ),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(path: '/types', builder: (context, state) => MbtiTypesScreen()),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // google에서 제공하는 기본 커스텀 css를 사용하며
    // 특정경로를 개발자가 하나하나 설정하겠다.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,

            // 경로설정에 대한것은 : _router라는 변수이
            routerConfig: _router,

            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              // ThemeData와 같이 색상 팔레트를 설정하는 속성에는
                // 개발자가 작성한 변수명칭의 색상을 사용할 수 없음
                // Material 에서 만든 색상만 가능
              primarySwatch: AppColors.primary,
              // primarySwatch: AppColors.primary,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              )
            ),

            darkTheme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.indigo,
                scaffoldBackgroundColor: Colors.grey[900],
                appBarTheme: AppBarTheme(
                  backgroundColor: Colors.grey[850],
                  foregroundColor: Colors.white,
                )
            ),


          );
        },
      ),
      /* 추후 라이트 테마 다크 테마 만들어서 세팅
      * theme
      * darkTheme
      * themeMode
      * home을 사용할 때는 go_router 와 같이
      * 기본 메인 위치를 지정하지 않고, home을 기준으로
      * 경로이동없이 작성할 때 사용!
      * home : const HomeScreen(),
      * */
    );
  }
}
