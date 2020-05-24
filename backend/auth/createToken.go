package auth

import (
	"time"

	"github.com/dgrijalva/jwt-go"
)

// CreateToken creates token with email
func CreateToken(email string) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user": email,
		"exp":  time.Now().Add(time.Hour * time.Duration(1)).Unix(),
		"iat":  time.Now().Unix(),
	})
	tokenString, err := token.SignedString([]byte(AppKey))
	if err != nil {
		// w.WriteHeader(http.StatusInternalServerError)
		// io.WriteString(w, `{"error":"token_generation_failed"}`)
		return "nil", err
	}
	// io.WriteString(w, `{"token":"`+tokenString+`"}`)
	return tokenString, err
}
