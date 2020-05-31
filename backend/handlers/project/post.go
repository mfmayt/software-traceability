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
	ownerID := data.GetUserIDFromContext(r.Context())
	p.l.Printf("[DEBUG] Inserting user: %#v, from owner with id: %#v\n", project, ownerID)
	data.AddProject(*project, ownerID)
}
