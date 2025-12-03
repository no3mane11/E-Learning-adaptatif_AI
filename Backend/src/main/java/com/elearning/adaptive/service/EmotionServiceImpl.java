package com.elearning.adaptive.service;

import com.elearning.adaptive.dto.EmotionEventDTO;
import com.elearning.adaptive.dto.SessionStats;
import com.elearning.adaptive.entity.EmotionEvent;
import com.elearning.adaptive.repository.EmotionEventRepository;
import com.elearning.adaptive.repository.SessionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.OffsetDateTime;

@Service
@RequiredArgsConstructor
public class EmotionServiceImpl implements EmotionService {

    private final EmotionEventRepository repo;
    private final SessionRepository sessionRepo;

    /**
     * Enregistre un nouvel événement émotionnel après validation minimale.
     */
    @Override
    @Transactional
    public EmotionEvent recordEmotion(EmotionEventDTO dto) {
        // Vérification que la session existe
        var sessionOpt = sessionRepo.findById(dto.sessionId());
        if (sessionOpt.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Session not found");
        }

        // Conversion du timestamp
        OffsetDateTime ts = OffsetDateTime.parse(dto.timestamp());

        // Création de l'entité
        EmotionEvent ev = EmotionEvent.builder()
                .sessionId(dto.sessionId())
                .timestamp(ts)
                .frustrationScore(dto.frustrationScore())
                .faceDetected(dto.faceDetected())
                .metaJson(dto.metaJson())
                .build();

        // Persistance
        return repo.save(ev);
    }

    /**
     * Calcule les statistiques pour une session sur une fenêtre temporelle donnée.
     */
    @Override
    public SessionStats getSessionStats(String sessionId, int windowSeconds) {
        OffsetDateTime since = OffsetDateTime.now().minusSeconds(windowSeconds);

        var events = repo.findBySessionIdAndTimestampAfter(sessionId, since);

        double avg = events.stream()
                .mapToDouble(EmotionEvent::getFrustrationScore)
                .average()
                .orElse(0.0);

        double max = events.stream()
                .mapToDouble(EmotionEvent::getFrustrationScore)
                .max()
                .orElse(0.0);

        long countHigh = events.stream()
                .filter(e -> e.getFrustrationScore() > 0.7)
                .count();

        return new SessionStats(sessionId, avg, max, countHigh, events.size());
    }
}
