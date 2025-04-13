package top.wmd001.util;

import cn.hutool.jwt.JWT;
import cn.hutool.jwt.JWTUtil;
import top.wmd001.config.JwtConfig;

import java.nio.charset.StandardCharsets;
import java.util.Map;

public class JwtUtil {

    /**
     * 生成 jwt token， 里边包含用户名和到期时间
     * @param username 用户名
     * @return jwt token
     */
    public static String generateToken(String username) {

        Map<String, Object> claims = Map.of(
                "username", username,
                "login_time", System.currentTimeMillis(),
                "expire_time", System.currentTimeMillis() + JwtConfig.expire
        );
        return JWTUtil.createToken(claims, JwtConfig.authorizationHeader.getBytes(StandardCharsets.UTF_8));
    }


    public static boolean isTokenExpired(String token) {
        // 验证token是否正确
        boolean verify = JWTUtil.verify(token, JwtConfig.sale.getBytes(StandardCharsets.UTF_8));
        if (verify) {
            // 验证token是否在有效期
            JWT jwt = JWTUtil.parseToken(token);
            long expireTime = (long) jwt.getPayload("expire_time");
            return System.currentTimeMillis() > expireTime;
        } else {
            return true;
        }
    }

    public static String getUsername(String token) {
        JWT jwt = JWTUtil.parseToken(token);
        return jwt.getPayload("username").toString();
    }

}
