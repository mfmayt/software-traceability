package auth

import (
	"time"

	data "traceability/data"

	"github.com/dgrijalva/jwt-go"
)

// CreateToken creates token with email
func CreateToken(email string) (string, error) {
	user, err := data.FindUserByEmail(email)

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"userid": user.ID,
		"exp":    time.Now().Add(time.Hour * time.Duration(1000)).Unix(),
		"iat":    time.Now().Unix(),
	})
	tokenString, err := token.SignedString([]byte(AppKey))
	if err != nil {
		return "nil", err
	}
	return tokenString, err
}
