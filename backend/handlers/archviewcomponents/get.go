package handlers

import (
	"io"
	"net/http"

	data "traceability/data"

	"github.com/gorilla/mux"
)

// GetArchViewComponent handles GET requests and returns the archview by ID
func (ac *ArchViewComponents) GetArchViewComponent(rw http.ResponseWriter, r *http.Request) {
	rw.Header().Add("Content-Type", "application/json")

	vars := mux.Vars(r)
	id, ok := vars["id"]
	viewID, ok := vars["viewID"]

	if !ok {
		io.WriteString(rw, `{{"error": "id not found"}}`)
		return
	}

	archViewComponent, err := data.FindArchViewComponentByID(id, viewID)

	if err != nil {
		http.Error(rw, `{{"error": "component not found"}}`, http.StatusInternalServerError)
		return
	}

	err = data.ToJSON(archViewComponent, rw)
}
