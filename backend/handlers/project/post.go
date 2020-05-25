package handlers

import (
	"net/http"
	data "traceability/data"
)

// swagger:route POST /project CreateProject
// Create a new project
//
// responses:
//	200: productResponse
//  422: errorValidation
//  501: errorResponse

// CreateProject handles POST requests to add new user
func (p *Projects) CreateProject(rw http.ResponseWriter, r *http.Request) {
	project := r.Context().Value(KeyProject{}).(*data.Project)
	p.l.Printf("[DEBUG] Inserting user: %#v\n", project)
	data.AddProject(*project, "TODO: id of the owner")
}
