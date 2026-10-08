package br.com.camplana.security;

import br.com.camplana.repository.UsuarioRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

@Component
public class SecurityFilter extends OncePerRequestFilter {

    @Autowired
    private JwtService jwtService;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private org.springframework.core.env.Environment env;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        
        // Trata o header X-Usuario-Dev apenas no profile "dev"
        boolean isDevProfile = List.of(env.getActiveProfiles()).contains("dev");
        String devHeader = request.getHeader("X-Usuario-Dev");
        if (isDevProfile && devHeader != null && !devHeader.isBlank()) {
            try {
                Integer devUserId = Integer.parseInt(devHeader);
                var devUserOpt = usuarioRepository.findById(devUserId);
                if (devUserOpt.isPresent()) {
                    var devUser = devUserOpt.get();
                    var authentication = new UsernamePasswordAuthenticationToken(devUser, null, devUser.getAuthorities());
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                    filterChain.doFilter(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Ignore e segue pro JWT se o header estiver mal formatado
            }
        }

        // Fluxo normal com JWT
        String tokenJWT = recuperarToken(request);
        if (tokenJWT != null) {
            try {
                String subject = jwtService.getSubject(tokenJWT);
                var usuario = usuarioRepository.findByEmail(subject);
                
                if (usuario.isPresent()) {
                    var authUser = usuario.get();
                    var authentication = new UsernamePasswordAuthenticationToken(authUser, null, authUser.getAuthorities());
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                }
            } catch (Exception e) {
                // Token inválido: deixa seguir sem autenticar, o Spring Security vai bloquear depois (403/401)
            }
        }
        
        filterChain.doFilter(request, response);
    }

    private String recuperarToken(HttpServletRequest request) {
        String authorizationHeader = request.getHeader("Authorization");
        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            return authorizationHeader.replace("Bearer ", "");
        }
        return null;
    }
}
