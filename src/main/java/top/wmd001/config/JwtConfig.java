package top.wmd001.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class JwtConfig {

    public static String authorizationHeader;
    public static String sale;
    public static long expire;

    @Value("${jwt.authorizationHeader:Authorization}")
    public void setAuthorizationHeader(String authorizationHeader) {
        JwtConfig.authorizationHeader = authorizationHeader;
    }

    @Value("${jwt.sale:!@#$%^&*}")
    public void setSale(String sale) {
        JwtConfig.sale = sale;
    }

    @Value("${jwt.expire:3600000}")
    public void setExpire(long expire) {
        JwtConfig.expire = expire;
    }

}
