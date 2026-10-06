package com.banking.bank.Auth.Domain;


import jakarta.persistence.*;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(
        name = "refresh_tokens",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_refresh_tokens_token_hash",
                        columnNames = "token_hash"
                )
        },
        indexes = {
                @Index(
                        name = "idx_refresh_tokens_user_id",
                        columnList = "user_id"
                )
        }
)


public class RefreshToken {
    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "user_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "fk_refresh_tokens_user")
    )
    private User user;

    @Column(name = "token_hash", nullable = false)
    private String tokenHash;

    @Column(nullable = false)
    private Instant expiresAt;

    @Column
    private Instant revokedAt;

    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    protected RefreshToken() {}
    public RefreshToken(
            User user,
            String tokenHash,
            Instant expiresAt
    ){
        this.user = user;
        this.tokenHash = tokenHash;
        this.expiresAt = expiresAt;
        this.createdAt = Instant.now();
    }

    public UUID getId(){
        return id;
    }

    public User getUser(){
        return user;
    }

    public String getTokenHash(){
        return tokenHash;
    }

    public Instant getExpiresAt(){
        return expiresAt;
    }

    public Instant getRevokedAt(){
        return revokedAt;
    }

    public Instant getCreatedAt(){
        return createdAt;
    }

}
