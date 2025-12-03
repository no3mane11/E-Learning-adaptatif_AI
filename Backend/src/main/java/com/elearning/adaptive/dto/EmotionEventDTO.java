package com.elearning.adaptive.dto;

public record EmotionEventDTO(
        String sessionId,
        String timestamp,           // ISO-8601 string, exemple "2025-11-30T13:00:00Z"
        double frustrationScore,
        boolean faceDetected,
        String metaJson
) {}

