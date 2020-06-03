package handlers

import (
	"net/http"
	data "traceability/data"
)

// swagger:route POST /project/{projectID}/views/{id} AddArchViewComponent
// Create a new project
//
// responses:
//	200: productResponse
//  422: errorValidation
//  501: errorResponse

// AddArchViewComponent handles POST requests to add new component
func (ac *ArchViewComponents) AddArchViewComponent(rw http.ResponseWriter, r *http.Request) {
	archViewComponent := r.Context().Value(KeyArchViewComponent{}).(*data.ArchViewComponent)

	ac.l.Printf("[DEBUG] Inserting archview component: %#v, to project", archViewComponent)
	data.AddArchViewComponent(*archViewComponent)
}
