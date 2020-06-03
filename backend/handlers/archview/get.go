package handlers

import (
	"io"
	"net/http"

	data "traceability/data"

	"github.com/gorilla/mux"
)

// GetArchView handles GET requests and returns the archview by ID
func (aw *ArchViews) GetArchView(rw http.ResponseWriter, r *http.Request) {
	rw.Header().Add("Content-Type", "application/json")

	vars := mux.Vars(r)
	id, ok := vars["id"]
	projectID, ok := vars["projectID"]

	if !ok {
		io.WriteString(rw, `{{"error": "id not found"}}`)
		return
	}

	userID := data.GetUserIDFromContext(r.Context())
	isMember := data.UserHasPermission(projectID, userID, "member")
	isOwmer := data.UserHasPermission(projectID, userID, "owner")

	if userID == "" || (!isOwmer && !isMember) {
		io.WriteString(rw, `{{"error": "401 user not authenticated"}}`)
		return
	}

	archView, err := data.FindArchViewByID(id)

	if err != nil {
		io.WriteString(rw, `{{"error": "architecture view not found"}}`)
		return
	}

	err = data.ToJSON(archView, rw)
}
