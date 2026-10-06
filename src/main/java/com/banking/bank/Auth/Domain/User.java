package com.banking.bank.Auth.Domain;

import jakarta.persistence.*;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name="users",
uniqueConstraints = {
        @UniqueConstraint(name="uk_users_email", columnNames = "email")
})
public class User {

    @Id
    @GeneratedValue
    private UUID id;

    @Column(nullable = false)
    private String email;

    @Column(nullable = false)
    private String passwordHash;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private UserStatus status;

    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    @Column(nullable = false)
    private Instant updatedAt;

    protected User() {

    }

    public User(
            String email,
            String passwordHash,
            Role role,
            UserStatus status
    ){
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.status = status;
        this.createdAt = Instant.now();
        this.updatedAt = Instant.now();
    }

    @PreUpdate
    protected void onUpdate(){
        this.updatedAt = Instant.now();
    }

    public UUID getId(){
        return id;
    }

    public String getEmail(){
        return email;
    }

    public String getPasswordHash(){
        return passwordHash;
    }

    public Role getRole(){
        return role;
    }

    public UserStatus getStatus(){
        return status;
    }

    public Instant getCreatedAt(){
        return createdAt;
    }

    public Instant getUpdatedAt(){
        return updatedAt;
    }

}
