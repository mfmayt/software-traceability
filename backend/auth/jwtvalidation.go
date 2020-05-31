package auth

import (
	"log"
	"net/http"

	jwtmiddleware "github.com/auth0/go-jwt-middleware"
	"github.com/dgrijalva/jwt-go"
)

const (
	// AppKey is used as app key for token creation
	AppKey = "gucluler.com"
)

// Middleware is our middleware to check our token is valid. Returning
// a 401 status to the client if it is not valid.
func Middleware(next http.Handler) http.Handler {
	if len(AppKey) == 0 {
		log.Fatal("HTTP server unable to start, expected an APP_KEY for JWT auth")
	}

	jwtMiddleware := jwtmiddleware.New(jwtmiddleware.Options{
		ValidationKeyGetter: func(token *jwt.Token) (interface{}, error) {
			return []byte(AppKey), nil
		},
		SigningMethod: jwt.SigningMethodHS256,
	})

	return jwtMiddleware.Handler(next)
}
