import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/*
* 초기에 만들어진 게스트섹션은 input 입력창이 존재하지 않은 상태에서 만들었기 때문에
* less
*
* input 창이 생성되었고, 화면은 클라이언트가 작성하는 명칭을 기준으로 변환
* -> ful
*
*
* */
class GuestSection extends StatefulWidget {
  final TextEditingController abc;
  final String? eText;
  final Function(String?) onErrorChanged;

  const GuestSection({
    required this.abc,
    this.eText,
    required this.onErrorChanged
});

  @override
  State<GuestSection> createState() => _GuestSectionState();
}

class _GuestSectionState extends State<GuestSection> {

  bool _validateName() {
    // 만약에 부모로부터 받은 변수의 컨트롤러를 사용한다면
    String name = widget.abc.text.trim();

    // 1. 빈 값 체크
    if (name.isEmpty) {
      widget.onErrorChanged("이름을 입력해주세요.");
      return false;
    }

    // 2. 글자 수 체크 (2글자 미만)
    if (name.length < 2) {
      widget.onErrorChanged('이름은 최소 2글자 이상이어야 합니다.');
      return false;
    }

    if (!RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(name)) {
      widget.onErrorChanged('한글 또는 영문만 입력 가능합니다\n(특수문자, 숫자 불가).');
      return false;
    }

    // 통과 시 에러 메세지 비움
    widget.onErrorChanged(null);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: () => context.go("/login"),
            child: Text('로그인하기', style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        /*
        전체주석 시작 코드 감싸기

        Dart 이중 주석 가능

        /시작주석
            /시작주석

             대신 시작 주석과 종료주석의 개수가 동일해야지만 가능
             시작 주석은 주석 주석 주석 3개인데 종료 주석은 2가지이면 2가지까지만 주석 닫힌 형태

             시작 주석 한가지는 주석이 끝나지 않은 상태로 남아있게 된다.

            종료주석/
        종료주석/
        전체주석 코드감싸기 종료


        SizedBox(height: 40),





        // 과제 : 이름을 입력하세요 는 게스트 섹션에서 사용
        // 로그인에 성공한 유저의 이름 표기
        SizedBox(
          width: 300,
          child: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: '이름',
              hintText: '이름을 입력하세요.',
              border: OutlineInputBorder(),
              errorText: _errorText,
            ),
            onChanged: (value) {
              // 모든 상태 실시간 변경은 setState(() => {
              //
              // }) 내부에 작성
              // setState() 로 감싸지 않은 if-else 문은
              // 변수 값만 변경 -> 변수값은 변화하지만 화면 업데이트는 안됨
              // setState() 로 감싼        if-else 문은
              // 화면 자동으로 업데이트되도록 상태 변경
              setState(() {
                if (RegExp(r'[0-9]').hasMatch(value)) {
                  _errorText = '숫자는 입력할 수 없습니다.';
                } else if (RegExp(
                  r'[^가-힣a-zA-Z]',
                ).hasMatch(value)) {
                  _errorText = '한글과 영어만 입력 가능합니다.';
                } else {
                  _errorText = null;
                }
              });
            },
            /*
                    _validateName() 을 onChanged 에서는 사용하지 않음
                    글자를 입력하면 무조건 에러 메세지를 비워라
                    1111을 입력하는 순간에도 계속 에러 메세지를 지워버리기 때문에
                    정상적으로 _errorText 작동하나 마치 작동하지 않는 것처럼 보임
                    onChanged: (value) {
                      if(_errorText != null) {
                        setState(() {
                          _errorText = null;
                        });
                      }
                    },
                     */
          ),
        ),
        */
        SizedBox(height: 20),
        SizedBox(
          width: 300,
          child: TextField(
            controller: widget.abc,
            decoration: InputDecoration(
              labelText: '이름',
              hintText: '이름을 입력하세요.',
              border: OutlineInputBorder(),
              errorText: widget.eText,
            ),
            onChanged: (value) {
              // 모든 상태 실시간 변경은 setState(() => {
              //
              // }) 내부에 작성
              // setState() 로 감싸지 않은 if-else 문은
              // 변수 값만 변경 -> 변수값은 변화하지만 화면 업데이트는 안됨
              // setState() 로 감싼        if-else 문은
              // 화면 자동으로 업데이트되도록 상태 변경
                if (RegExp(r'[0-9]').hasMatch(value)) {
                  widget.onErrorChanged('숫자는 입력할 수 없습니다.');
                } else if (RegExp(
                  r'[^가-힣a-zA-Z]',
                ).hasMatch(value)) {
                  widget.onErrorChanged('한글과 영어만 입력 가능합니다.');
                } else {
                  widget.onErrorChanged(null);
                }

            },

          ),
        ),

        SizedBox(height: 20),
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              print("버튼눌림");
              // 인풋창에 데이터가 존재해야지만 검사 결과로 이동할 수 있기 때문에 현재는 이동할 수 없는 상태
              if (_validateName()) {
                print("검사 결과");
                String name = widget.abc.text.trim();
                // 작성한 이름유저의 mbti 결과 확인
                print("기록으로 이동하는 주소 위치");
                context.go("/history", extra: name);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black87,
            ),
            child: Text("이전 결과 보기"),
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: () => context.go('/signup'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text("회원가입하기"),
          ),
        ),
      ],
    );
  }
}