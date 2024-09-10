package org.example.blogserver.entity;

import java.io.Serializable;

public record Message(String role, String content) implements Serializable {
}
