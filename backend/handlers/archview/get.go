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
