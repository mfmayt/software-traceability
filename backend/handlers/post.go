package handlers

import (
	"net/http"
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
func (p *Users) CreateUser(rw http.ResponseWriter, r *http.Request) {
	user := r.Context().Value(KeyUser{}).(*data.User)
	p.l.Printf("[DEBUG] Inserting user: %#v\n", user)
	data.AddUser(*user)
}
