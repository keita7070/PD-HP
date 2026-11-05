package config

import (
	"errors"
	"os"
)

type Config struct {
	Port          string
	DatabaseURL   string
	AdminPassword string
	SessionSecret string
	CookieSecure  bool
}

func Load() (Config, error) {
	c := Config{
		Port:          getenv("PORT", "8080"),
		DatabaseURL:   os.Getenv("DATABASE_URL"),
		AdminPassword: os.Getenv("ADMIN_PASSWORD"),
		SessionSecret: os.Getenv("SESSION_SECRET"),
		CookieSecure:  os.Getenv("COOKIE_SECURE") == "true",
	}
	if c.DatabaseURL == "" {
		return c, errors.New("DATABASE_URL が未設定です")
	}
	if c.AdminPassword == "" {
		return c, errors.New("ADMIN_PASSWORD が未設定です")
	}
	if len(c.SessionSecret) < 32 {
		return c, errors.New("SESSION_SECRET は32文字以上にしてください")
	}
	return c, nil
}

func getenv(key, def string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return def
}
