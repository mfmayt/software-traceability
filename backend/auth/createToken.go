package auth

import (
	"time"

	"github.com/dgrijalva/jwt-go"
)

// CreateToken creates token with email
func CreateToken(email string) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user": email,
		"exp":  time.Now().Add(time.Hour * time.Duration(1000)).Unix(),
		"iat":  time.Now().Unix(),
	})
	tokenString, err := token.SignedString([]byte(AppKey))
	if err != nil {
		return "nil", err
	}
	return tokenString, err
}
