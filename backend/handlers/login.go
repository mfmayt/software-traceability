package handlers

import (
	"io"
	"net/http"
	authentication "traceability/auth"
	data "traceability/data"
)

// swagger:route POST /login users LoginUser
// Login the user
//
// responses:
//	200: productResponse
//  422: errorValidation
//  501: errorResponse

// LoginUser handles POST requests to login the user
func (p *Users) LoginUser(rw http.ResponseWriter, r *http.Request) {
	auth := r.Context().Value(KeyAuth{}).(*data.Auth)
	p.l.Printf("[DEBUG] Login user: %#v\n", auth)

	if auth.Email != "fatih@fatih.com" || auth.Password != "111111" {
		rw.WriteHeader(http.StatusUnauthorized)
		io.WriteString(rw, `{"error":"invalid_credentials"}`)
		return
	}

	rw = authentication.CreateToken(auth.Email, rw)
	return
}
