package com.elearning.adaptive.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "sessions")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Session {

    @Id
    @Column(length = 36)
    private String id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private User student;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lesson_id", nullable = false)
    private Lesson lesson;

    @Column(nullable = false)
    private OffsetDateTime startedAt = OffsetDateTime.now();

    private OffsetDateTime endedAt;

    @Column(nullable = false, length = 20)
    private String status; // ACTIVE, ENDED

    // Optionnel : méthode helper pour terminer la session
    public void endSession() {
        this.endedAt = OffsetDateTime.now();
        this.status = "ENDED";
    }
}
