package handlers

import (
	"net/http"

	data "traceability/data"
)

// swagger:route GET /users listUsers
// Return a list of users from the database
// responses:
// 200: usersResponse

// ListAll handles GET requests and returns all current users
func (u *Users) ListAll(rw http.ResponseWriter, r *http.Request) {
	u.l.Println("[DEBUG] get all records")
	rw.Header().Add("Content-Type", "application/json")

	prods := data.GetAllUsers()

	err := data.ToJSON(prods, rw)
	if err != nil {
		// we should never be here but log the error just incase
		u.l.Println("[ERROR] serializing product", err)
	}
}
