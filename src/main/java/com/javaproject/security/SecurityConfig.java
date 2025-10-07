package com.javaproject.security;

import jakarta.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private LoggingAccessDeniedHandler accessDeniedHandler;

    @Autowired
    public void setAccessDeniedHandler(LoggingAccessDeniedHandler accessDeniedHandler) {
        this.accessDeniedHandler = accessDeniedHandler;
    }

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Autowired
    @Lazy
    private BCryptPasswordEncoder passwordEncoder;

    @Autowired
    private DataSource dataSource;

    /**
     * Creates a bean of type JdbcUserDetailsManager that will be used in
     * HomeController
     *
     * @return an instance configured to use our datasource
     * @throws Exception
     */
    @Bean
    public JdbcUserDetailsManager jdbcUserDetailsManager() throws Exception {
        // provides crud operations for users
        JdbcUserDetailsManager jdbcUserDetailsManager = new JdbcUserDetailsManager();

        // Link up with our datasource
        jdbcUserDetailsManager.setDataSource(dataSource);

        // Create default users
        jdbcUserDetailsManager.createUser(
            org.springframework.security.core.userdetails.User
                .withUsername("bugs")
                .password(passwordEncoder.encode("bunny"))
                .roles("USER")
                .build()
        );

        jdbcUserDetailsManager.createUser(
            org.springframework.security.core.userdetails.User
                .withUsername("daffy")
                .password(passwordEncoder.encode("duck"))
                .roles("USER", "MANAGER")
                .build()
        );

        return jdbcUserDetailsManager;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/user/**").hasAnyRole("USER", "MANAGER")
                .requestMatchers("/secured/**").hasAnyRole("USER", "MANAGER")
                .requestMatchers("/manager/**").hasRole("MANAGER")
                .requestMatchers("/h2-console/**").permitAll()
                .requestMatchers("/", "/**").permitAll()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .defaultSuccessUrl("/secured")
                .permitAll()
            )
            .logout(logout -> logout
                .invalidateHttpSession(true)
                .clearAuthentication(true)
                .permitAll()
            )
            .exceptionHandling(ex -> ex
                .accessDeniedHandler(accessDeniedHandler)
            )
            .csrf(csrf -> csrf.disable())
            .headers(headers -> headers.frameOptions(frame -> frame.disable()));

        return http.build();
    }
}
