package handlers

import (
	"io"
	"net/http"

	data "traceability/data"

	"github.com/gorilla/mux"
)

// GetArchViewComponent handles GET requests and returns the archview by ID
func (ac *ArchViewComponents) GetArchViewComponent(rw http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)
	id, ok := vars["id"]

	if !ok {
		io.WriteString(rw, `{{"error": "id not found"}}`)
		return
	}

	archViewComponent, err := data.FindArchViewComponentByID(id)

	if err != nil {
		http.Error(rw, `{{"error": "component not found"}}`, http.StatusInternalServerError)
		return
	}

	err = data.ToJSON(archViewComponent, rw)
}

// ListArchViewComponents handles GET requests and returns the archview by ID
func (ac *ArchViewComponents) ListArchViewComponents(rw http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)
	viewID, ok := vars["viewID"]

	if !ok {
		io.WriteString(rw, `{{"error": "id not found"}}`)
		return
	}

	archViewComponents, err := data.FindArchViewComponentsByViewID(viewID)

	if err != nil {
		http.Error(rw, `{{"error": "component not found"}}`, http.StatusInternalServerError)
		return
	}

	err = data.ToJSON(archViewComponents, rw)
}

// ListAllComponents handles GET requests
func (ac *ArchViewComponents) ListAllComponents(rw http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)
	projectID, ok := vars["projectID"]

	if !ok {
		io.WriteString(rw, `{{"error": "id not found"}}`)
		return
	}

	archViewComponents, err := data.FindArchViewComponentsByProjectID(projectID)

	if err != nil {
		http.Error(rw, `{{"error": "component not found"}}`, http.StatusInternalServerError)
		return
	}

	err = data.ToJSON(archViewComponents, rw)
}
