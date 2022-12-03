package com.lin.config;

import com.lin.interceptor.LoginInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * @author lkmc2
 * @date 2019/2/10
 * @description 网络配置
 */

@Configuration
public class WebConfigurer implements WebMvcConfigurer {

    @Autowired
    private LoginInterceptor loginInterceptor;

    @Value("${user.upload.file.path}")
    private String uploadFilepath;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String fileLocation = String.format("file:%s/", uploadFilepath);
        registry.addResourceHandler("/**")
                // 让从网址上访问的静态资源映射到本机指定位置
                .addResourceLocations(fileLocation);
    }

    // 这个方法用来注册拦截器，我们自己写好的拦截器需要通过这里添加注册才能生效
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // addPathPatterns("/**") 表示拦截所有的请求，
        // excludePathPatterns("/user/login") 表示除了登陆之外，因为登陆不需要登陆也可以访问
        registry.addInterceptor(loginInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns("/user/login", "/static/**");
    }

}

