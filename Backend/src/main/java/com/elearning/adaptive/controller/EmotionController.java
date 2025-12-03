package com.elearning.adaptive.controller;

import com.elearning.adaptive.dto.EmotionEventDTO;
import com.elearning.adaptive.entity.EmotionEvent;
import com.elearning.adaptive.service.EmotionService;
import com.elearning.adaptive.dto.SessionStats;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/sessions")
@RequiredArgsConstructor
public class EmotionController {

    private final EmotionService emotionService;

    /**
     * Ingestion d'un événement émotionnel pour une session spécifique.
     */
    @PostMapping("/{sessionId}/emotion")
    public ResponseEntity<?> ingestSingle(
            @PathVariable String sessionId,
            @RequestBody EmotionEventDTO body
    ) {
        // Assurer que sessionId de l'URL correspond à celui du body
        EmotionEventDTO dto = new EmotionEventDTO(
                sessionId,
                body.timestamp(),
                body.frustrationScore(),
                body.faceDetected(),
                body.metaJson()
        );

        EmotionEvent saved = emotionService.recordEmotion(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(Map.of("id", saved.getId()));
    }

    /**
     * Récupère les statistiques d'une session sur une fenêtre de temps donnée.
     */
    @GetMapping("/{sessionId}/stats")
    public SessionStats getStats(
            @PathVariable String sessionId,
            @RequestParam(defaultValue = "60") int windowSeconds
    ) {
        return emotionService.getSessionStats(sessionId, windowSeconds);
    }
}
