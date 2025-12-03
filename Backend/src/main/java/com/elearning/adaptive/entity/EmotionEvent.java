package com.elearning.adaptive.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "emotion_events", indexes = {
        @Index(name = "idx_session_time", columnList = "session_id, timestamp")
})
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EmotionEvent {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "session_id", nullable = false)
    private String sessionId; // UUID de la session

    @Column(nullable = false)
    private OffsetDateTime timestamp = OffsetDateTime.now();

    @Column(nullable = false)
    private double frustrationScore; // 0.0 - 1.0

    @Column(nullable = false)
    private boolean faceDetected;

    @Column(columnDefinition = "text")
    private String metaJson; // données additionnelles (vecteur émotion, bounding box, etc.)

    // Optionnel : relation vers Session si tu veux naviguer facilement
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "session_id", referencedColumnName = "id", insertable = false, updatable = false)
    private Session session;
}
