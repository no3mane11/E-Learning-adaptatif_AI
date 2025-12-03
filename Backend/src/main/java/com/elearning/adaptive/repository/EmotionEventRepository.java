package com.elearning.adaptive.repository;

import com.elearning.adaptive.entity.EmotionEvent;
import org.springframework.data.jpa.repository.JpaRepository;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

public interface EmotionEventRepository extends JpaRepository<EmotionEvent, Long> {

    // Récupérer tous les événements d'une session après une certaine date/heure
    List<EmotionEvent> findBySessionIdAndTimestampAfter(String sessionId, OffsetDateTime after);

    // Récupérer le dernier événement d'une session
    Optional<EmotionEvent> findFirstBySessionIdOrderByTimestampDesc(String sessionId);
}

