package auth

import (
	"fmt"
	"io"
	"log"
	"net/http"

	data "traceability/data"

	jwtmiddleware "github.com/auth0/go-jwt-middleware"
	"github.com/dgrijalva/jwt-go"
	"github.com/gorilla/mux"
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

// ProjectAuthMiddleware authenticate user to project
func ProjectAuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(rw http.ResponseWriter, r *http.Request) {

		vars := mux.Vars(r)
		projectID, ok := vars["projectID"]
		fmt.Println(r)
		if !ok {
			io.WriteString(rw, `{{"error": "id not found"}}`)
			return
		}

		userID := data.GetUserIDFromContext(r.Context())
		isMember := data.UserHasPermission(projectID, userID, "member")
		isOwner := data.UserHasPermission(projectID, userID, "owner")

		if userID == "" || (!isOwner && !isMember) {
			http.Error(rw, `{{"error": "401 user not authenticated"}}`, http.StatusUnauthorized)
			return
		}
		next.ServeHTTP(rw, r)
	})
}

// CORS Middleware
func CORS(h http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		origin := r.Header.Get("Origin")
		w.Header().Set("Access-Control-Allow-Origin", origin)
		w.Header().Add("Content-Type", "application/json")
		if r.Method == "OPTIONS" {
			w.Header().Set("Access-Control-Allow-Methods", "GET,POST,PATCH")
			w.Header().Set("Access-Control-Allow-Headers", "Content-Type, X-CSRF-Token, Authorization")
		} else {
			h.ServeHTTP(w, r)
		}
	})
}
