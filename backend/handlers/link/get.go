package handlers

import (
	"io"
	"net/http"

	data "traceability/data"

	"github.com/gorilla/mux"
)

// swagger:route GET /links listUsers
// Return a list of users from the database
// responses:
// 200: usersResponse

// ListAll handles GET requests and returns all links
func (l *Links) ListAll(rw http.ResponseWriter, r *http.Request) {
	l.l.Println("[DEBUG] get all links")
	rw.Header().Add("Content-Type", "application/json")

	links := data.FindAllLinks()

	err := data.ToJSON(links, rw)
	if err != nil {
		l.l.Println("[ERROR] serializing link", err)
	}
}

// swagger:route GET /projects/{projectID}/links/{linkID} listUsers
// Return a list of users from the database
// responses:
// 200: usersResponse

// GetLink handles GET requests and returns all links
func (l *Links) GetLink(rw http.ResponseWriter, r *http.Request) {
	rw.Header().Add("Content-Type", "application/json")

	vars := mux.Vars(r)
	id, ok := vars["linkID"]
	// projectID, ok := vars["projectID"]

	if !ok {
		io.WriteString(rw, `{{"error": "id not found"}}`)
		return
	}

	link, err := data.FindLinkByID(id)

	if err != nil {
		io.WriteString(rw, `{{"error": "link not found"}}`)
		return
	}

	err = data.ToJSON(link, rw)
}

// swagger:route GET /projects/{projectID}/ listUsers
// Return a list of users from the database
// responses:
// 200: usersResponse

// GetProjectLinks handles GET requests and returns all links
func (l *Links) GetProjectLinks(rw http.ResponseWriter, r *http.Request) {
	rw.Header().Add("Content-Type", "application/json")

	vars := mux.Vars(r)
	projectID, ok := vars["projectID"]

	if !ok {
		io.WriteString(rw, `{{"error": "id not found"}}`)
		return
	}

	project, err := data.FindAllProjectLinks(projectID)

	if err != nil {
		io.WriteString(rw, `{{"error": "user not found"}}`)
		return
	}

	err = data.ToJSON(project, rw)
}
