package top.wmd001.common;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Component;

@Component
public class TokenManager {

    @CachePut(value = "auth-token", key = "#token")
    public long cacheToken(String token) {
        return System.currentTimeMillis();
    }

    @CacheEvict(value = "auth-token", key = "#token")
    public void clearToken(String token) {

    }

    @Cacheable(value = "auth-token", key = "#token")
    public long getLastAction(String token) {
        return 0;
    }


}
