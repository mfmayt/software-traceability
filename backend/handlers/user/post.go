package handlers

import (
	"io"
	"net/http"
	"time"
	authentication "traceability/auth"
	data "traceability/data"
)

// swagger:route POST /user users createUser
// Create a new user
//
// responses:
//	200: productResponse
//  422: errorValidation
//  501: errorResponse

// CreateUser handles POST requests to add new user
func (u *Users) CreateUser(rw http.ResponseWriter, r *http.Request) {
	user := r.Context().Value(KeyUser{}).(*data.User)
	u.l.Printf("[DEBUG] Inserting user: %#v\n", user)
	accessToken, err := authentication.CreateToken(user.Email)

	if err != nil {
		rw.WriteHeader(http.StatusInternalServerError)
		io.WriteString(rw, `{{"error":"server is not working"}}`)
		return
	}

	user.AccessToken = accessToken
	expirationTime := time.Now().Add(1200 * time.Hour)

	http.SetCookie(rw, &http.Cookie{
		Name:    "accesstoken",
		Value:   accessToken,
		Expires: expirationTime,
	})

	resultUser := data.AddUser(*user)
	data.ToJSON(*resultUser, rw)
}
