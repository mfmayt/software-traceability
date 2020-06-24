package handlers

import (
	"io"
	"net/http"
	data "traceability/data"

	"github.com/gorilla/mux"
)

// swagger:route POST /project CreateProject
// Create a new project
//
// responses:
//	200: productResponse
//  422: errorValidation
//  501: errorResponse

// CreateArchView handles POST requests to add new architecture view
func (aw *ArchViews) CreateArchView(rw http.ResponseWriter, r *http.Request) {
	archView := r.Context().Value(KeyArchView{}).(*data.ArchView)

	vars := mux.Vars(r)
	projectID, ok := vars["projectID"]

	if !ok {
		io.WriteString(rw, `{{"error": "id not found"}}`)
		return
	}

	archView.ProjectID = projectID
	_, err := data.AddArchView(*archView)
	if err != nil {
		io.WriteString(rw, `{{"error": "architecture view couldn't be added"}}`)
	}
}
