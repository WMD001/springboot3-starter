package top.wmd001.contorller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import top.wmd001.common.TokenManager;
import top.wmd001.config.JwtConfig;
import top.wmd001.util.JwtUtil;

@RestController
public class TokenController {

    private final TokenManager tokenManager;


    public TokenController(TokenManager tokenManager) {
        this.tokenManager = tokenManager;
    }

    @GetMapping("/login")
    public String login(String username, String password) {
        String token = JwtUtil.generateToken(username);
        tokenManager.cacheToken(token);
        return token;
    }

    @GetMapping("/verify")
    public String verify(HttpServletRequest request) {
        String token = request.getHeader(JwtConfig.authorizationHeader);
        if (tokenManager.getLastAction(token) <= 0) {
            return "Token Invalid";
        }
        return JwtUtil.isTokenExpired(token) ? "Token Expired" : "Token not Expired";
    }

}
