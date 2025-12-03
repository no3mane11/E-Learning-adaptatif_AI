package com.elearning.adaptive.repository;

import com.elearning.adaptive.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    // Permet de rechercher un utilisateur par email
    Optional<User> findByEmail(String email);
}
