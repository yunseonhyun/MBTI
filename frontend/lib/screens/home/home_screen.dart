import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/widgets/home/guest_section.dart';
import 'package:frontend/widgets/home/profile_menu.dart';
import 'package:frontend/widgets/home/user_section.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/*
lib/
├─────screens/
│        └───── home_screen.dart                (메인 홈 화면 : 조립하는 역할)
│
├─────widgets/
│        └───── home/                           (홈 화면 전용 위젯 폴더 생성)
│                 ├───── guest_section.dart     (로그인 전 화면)
│                 ├───── user_section.dart      (로그인 후 화면 + 입력 로직)
│                 └───── profile_menu.dart      (앱바 프로필 메뉴)
│
│

 */
// 상태에 따른 화면 변화가 일어날 예정
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // HomeScreen 내부에서 사용할 변수이름, 함수 이름 작성
  /*
  만약에 Input이나 Textarea를 사용할 경우에는 사용자들이 작성한 값(value)를 읽고
  읽은 value 데이터를 가져오기 위해 기능 작성해야함
  -> dart에서는 TextEditingController 객체를 미리 만들어 놓았음

  사용방법
  1. 컨트롤러 상태를 담을 변수 공간 설정 _ private 설정을 안해도 됨
  2. TextField에 연결
  TextField(
      controller:_nameController 와 같은 형태로 내부에서 작성된 value를 연결
  )

  3. 값을 가져와서 확인하거나 사용하기
  String name = _nameController.text;
  */
  final TextEditingController _nameController = TextEditingController();

  String? _errorText;

  // 홈화면 시작하자마자 실행할 기능들 세팅
  // git iinit -> git 초기세팅처럼 init 초기 세팅
  // state 상태 변화 기능
  // initState() -> 위젯 화면을 보여줄 때 초기 상태 화면 변화하여 보여준다.
  // ex 화면에서 backend 데이터를 가져오겠다. 로그인 상태 복원하겠다.
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadSaveUser();
    });
  } // 에러 메세지를 담을 변수 ? = 변수 공간에 null 들어갈 수 있다.


  // 유효성 검사 함수
  // 기능 중에 일부라도 문법상 문제가 생기면 기능 자체가 작동 중지
  bool _validateName() {
    String name = _nameController.text.trim();

    // 1. 빈 값 체크
    if (name.isEmpty) {
      setState(() {
        _errorText = '이름을 입력해주세요.';
      });
      return false;
    }

    // 2. 글자수 체크 (2글자 미만)
    if (name.length < 2) {
      setState(() {
        _errorText = '이름은 최소 2글자 이상이어야 합니다.';
      });
      return false;
    }

    // 3. 한글/영문 이외 특수문자나 숫자 포함 체크 여부(정규식)
    // 만약 숫자도 허용하려면 r'^[가-힇-a-zA-Z0-9]+$'로 변경
    // 만약 숫자도 허용하려면 r'^[가-힇-a-zA-Z0-9]+$'- : 어디서부터 어디까지
    // 가-힇 가에서부터 힇까지 힇에서 a까지는 잘못된 문법 정규식 동작 안함
    if (!RegExp(r'^[가-힇a-zA-Z]+$').hasMatch(name)) {
      setState(() {
        _errorText = '한글 또는 영문만 입력 가능합니다\n(특수문자, 숫자 불가)';
      });
      return false;
    }

    // 통과 시 에러 메세지 비움
    setState(() {
      _errorText = null;
    });
    return true;
  }

  // UI 화면
  /*
    키보드를 화면에서 사용해야하는 경우
    화면이 가려지는 것을 방지하기 위해 스크롤 가능하게 처리
   */
  void _handleLogout() {
    showDialog(context: context,
        builder: (context) => AlertDialog(
          title: Text("로그아웃"),
          content: Text("로그아웃 하시겠습니까?"),
          actions: [
            //              과제       Navigator.pop(context) -> go_router 사용한 context로 교체하기
            TextButton(onPressed: () => Navigator.pop(context), child: Text("취소")),
            TextButton(onPressed: () async {
              await context.read<AuthProvider>().logout();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("로그아웃 되었습니다.")
                ),
              );
            }, child: Text("로그아웃", style: TextStyle(color:Colors.red),)),

          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer <AuthProvider>(
        builder: (context, authProvider, child) {
          final isLoggedIn = authProvider.isLoggedIn;
          final userName = authProvider.user?.userName;

          return Scaffold(
            appBar: AppBar(title: Text("MBTI 유형 검사"),
              actions: [
                // 로그인 상태에 따라 버튼 표기
                if(isLoggedIn)
                  // 분리된 프로필 메뉴 위젯에
                  // userName이라는 명칭으로 userName 내부 데이터 전달
                  // onLogout이라는 명칭으로 _handleLogout 기능 전달
                 ProfileMenu(userName: userName, onLogout: _handleLogout)

              ],
            ),

            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.psychology, size: 100, color: Colors.blue),
                      SizedBox(height: 30),
                      Text(
                        '나의 성격을 알아보는 ${AppConstants.totalQuestions}가지 질문',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 40),
                      if(!isLoggedIn)
                        GuestSection()
                      else
                        UserSection(),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(


                          onPressed: () => context.go('/types'),


                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[300],
                            foregroundColor: Colors.black87,
                          ),
                          child: Text("MBTI 유형 보기"),
                        ),
                      ),
                      SizedBox(height: 10),

                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
