package com.elearning.adaptive.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class SessionStats {
    private String sessionId;
    private double averageFrustration;
    private double maxFrustration;
    private long countHighFrustration;
    private int totalEvents;
}
