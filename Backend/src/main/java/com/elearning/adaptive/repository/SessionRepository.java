package com.elearning.adaptive.repository;

import com.elearning.adaptive.entity.Session;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface SessionRepository extends JpaRepository<Session, String> {

    // Trouver toutes les sessions d’un étudiant
    List<Session> findByStudentId(Long studentId);

    // Trouver toutes les sessions pour une leçon spécifique
    List<Session> findByLessonId(Long lessonId);

    // Trouver une session active par son ID
    Optional<Session> findByIdAndStatus(String id, String status);

    // Trouver toutes les sessions actives pour un étudiant
    List<Session> findByStudentIdAndStatus(Long studentId, String status);
}
