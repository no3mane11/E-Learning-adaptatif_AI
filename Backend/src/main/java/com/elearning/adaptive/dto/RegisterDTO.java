package com.elearning.adaptive.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class RegisterDTO {

    private final String fullName;
    private final String email;
    private final String password;
}
