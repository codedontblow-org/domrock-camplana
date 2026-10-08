package br.com.camplana.controller;

import br.com.camplana.dto.auth.LoginRequest;
import br.com.camplana.dto.auth.LoginResponse;
import br.com.camplana.entity.Usuario;
import br.com.camplana.security.JwtService;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@Slf4j
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private DaoAuthenticationProvider authenticationProvider;

    @Autowired
    private JwtService jwtService;

    @PostMapping("/login")
    public ResponseEntity<?> efetuarLogin(@RequestBody @Valid LoginRequest dto) {
        try {
            var authToken = new UsernamePasswordAuthenticationToken(dto.getEmail(), dto.getSenha());
            var authentication = authenticationProvider.authenticate(authToken);

            var usuario = (Usuario) authentication.getPrincipal();

            if (!usuario.getAtivo()) {
                return erroCredenciais();
            }

            var tokenJWT = jwtService.gerarToken(usuario);

            var response = LoginResponse.builder()
                    .token(tokenJWT)
                    .perfil(usuario.getPerfil().name())
                    .validade(jwtService.getExpirationDate())
                    .usuario(LoginResponse.LoginUserResponse.builder()
                            .id(usuario.getId())
                            .nome(usuario.getNome())
                            .email(usuario.getEmail())
                            .build())
                    .build();

            return ResponseEntity.ok(response);

        } catch (AuthenticationException e) {
            log.warn("Falha de autenticacao para email {}: {}", dto.getEmail(), e.getClass().getSimpleName());
            return erroCredenciais();
        }
    }

    private ResponseEntity<?> erroCredenciais() {
        var erro = br.com.camplana.exception.BadRequestExceptionDetails.builder()
                .timestamp(LocalDateTime.now())
                .status(401)
                .error("E-mail ou senha inválidos")
                .message("E-mail ou senha inválidos")
                .path("/api/auth/login")
                .build();
        return ResponseEntity.status(401).body(erro);
    }
}
