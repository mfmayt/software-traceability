package handlers

import (
	"io"
	"net/http"

	data "traceability/data"

	"github.com/gorilla/mux"
)

// GetArchView handles GET requests and returns the archview by ID
func (aw *ArchViews) GetArchView(rw http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)
	id, ok := vars["id"]

	if !ok {
		io.WriteString(rw, `{{"error": "id not found"}}`)
		return
	}

	archView, err := data.FindArchViewByID(id)

	if err != nil {
		io.WriteString(rw, `{{"error": "architecture view not found"}}`)
		return
	}

	err = data.ToJSON(archView, rw)
}

// ListArchViews handles GET requests and returns the list of archviews belongs to the project
func (aw *ArchViews) ListArchViews(rw http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)
	id, ok := vars["projectID"]
	aw.l.Println(id)
	if !ok {
		io.WriteString(rw, `{{"error": "id not found"}}`)
		return
	}

	archViews, err := data.FindArchViewsOfProject(id)

	if err != nil {
		io.WriteString(rw, `{{"error": "architecture view not found"}}`)
		return
	}
	aw.l.Println("archviews completed")
	err = data.ToJSON(archViews, rw)
}
