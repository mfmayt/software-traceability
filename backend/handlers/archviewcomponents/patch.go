package handlers

import (
	"encoding/json"
	"io"
	"io/ioutil"
	"net/http"

	data "traceability/data"

	jsonpatch "github.com/evanphx/json-patch"
	"github.com/gorilla/mux"
)

// UpdateArchViewComponent handles PATCH requests and updates archview component
func (ac *ArchViewComponents) UpdateArchViewComponent(rw http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)
	id, ok := vars["id"]
	jsonBody, err := ioutil.ReadAll(r.Body)

	if !ok {
		io.WriteString(rw, `{{"error": "id not found"}}`)
		return
	}

	component, err := data.FindProjectByID(id)

	if err != nil {
		http.Error(rw, `{{"error": "component view not found"}}`, http.StatusNotFound)
		return
	}
	jsonProj, err := json.Marshal(component)
	if err != nil {
		http.Error(rw, `{{"error": "architecture view not found"}}`, http.StatusInternalServerError)
		return
	}
	modifiedJSON, err := jsonpatch.MergePatch(jsonProj, jsonBody)
	modifiedComponent := &data.ArchViewComponent{}
	err = json.Unmarshal(modifiedJSON, modifiedComponent)
	data.UpdateArchViewComponent(*modifiedComponent)
	err = data.ToJSON(modifiedComponent, rw)
}
