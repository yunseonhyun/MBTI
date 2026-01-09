package com.mbti.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

//    @Value("${file.profile.upload.path}")
//    private String profileUploadPath;
//
//    @Value("${file.story.upload.path}")
//    private String storyUploadPath;
//
//    @Value("${file.post.upload.path}")
//    private String postUploadPath;

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                // REST API CORS 설정
                // edge chrome의 경우 개발자가 개발을 하기 위해 테스트모드
                // 1. debug print를 사용해서 개발자가 작성한 데이터나 기능 결과를 확인할 수 있음
                // 2. 테스트가 종료되고 나면 웹사이트를 필요로하지 않으나,
                // 3. 상황에 따라 테스트모드 웹사이트를 배포용 웹사이트
                // 4. 다시 시작할 때마다 변경되는 port 번호 변경할 수 있다.
                registry.addMapping("/api/**")
                        /*
                        .allowedOriginPatterns("*") + .allowCredentials(true)
                        -> 가능

                        .allowedOrigin("*") + .allowCredentials(true)
                        -> 함께 사용하면 .allowedOrigin 주소 문자열 내부에 * 사용 불가

                        .allowedOrigin("*") + .allowCredentials(false)
                        -> OK

                        .allowedOrigin("특정주소:특정포트", "특정주소:특정포트") + .allowCredentials(true)
                        -> *가 없으므로 가능 OK


                        .allowCredentials(true)
                        -> 프론트엔드와 백엔드 사이에서 다음 정보들이 오갈 수 있다.
                            쿠키(로그인 세션 ID), 인증 헤더 Bearer <토큰> 같은 헤더, 클라이언트 보안 인증서
                            -> 만약 false로 하면
                                -> 어라?? 보안 설정 때문에 쿠키 못보내네 ^^ 유감.. 매번 로그인 다시해
                                    -> 로그인이 풀리는 현상 발생

                        .allowedOrigins("*") -> 내 친군데 아무나 다와 ^^ (무책임함 -> 브라우저가 차단)

                        .allowedOriginPatterns("*") -> 제가 허용한 접속해도 되는 리스트들이에요 ^^ -> 네 이쪽사람들만 들어오세요

                            * 배포 치명적인 사유가 되므로, 반드시 개발 단계에서만 사용
                         */
                        .allowedOriginPatterns("http://localhost:*", "http://10.0.2.2:*") // 윈도우 / 웹 / IOS 시뮬레이터 모든 포트 허용
                                                                                   // 안드로이드 애뮬레이터 모든 포트 허용
                        .allowCredentials(true)
                        .allowedMethods("GET","POST","PUT","DELETE","PATCH","OPTIONS")
                        .allowedHeaders("*");

                // WebSocket CORS 설정 추가
                /*registry.addMapping("/ws/**")
                        .allowedOrigins("http://localhost:3001","http://localhost:3000", "http://localhost:57317")
                        .allowCredentials(true)
                        .allowedMethods("GET","POST","PUT","DELETE","PATCH","OPTIONS")
                        .allowedHeaders("*");*/
            }
        };
    }

 /*   @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/profile_images/**")
                .addResourceLocations("file:"+profileUploadPath+"/");

        registry.addResourceHandler("/story_images/**")
                .addResourceLocations("file:"+storyUploadPath + "/");

        registry.addResourceHandler("/post_images/**")
                .addResourceLocations("file:"+postUploadPath + "/");

    }*/
}
