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

// UpdateProject handles PATCH requests and updates project
func (p *Projects) UpdateProject(rw http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)
	id, ok := vars["projectID"]
	jsonBody, err := ioutil.ReadAll(r.Body)

	if !ok {
		io.WriteString(rw, `{{"error": "id not found"}}`)
		return
	}

	project, err := data.FindProjectByID(id)

	if err != nil {
		http.Error(rw, `{{"error": "architecture view not found"}}`, http.StatusNotFound)
		return
	}
	jsonProj, err := json.Marshal(project)
	if err != nil {
		http.Error(rw, `{{"error": "architecture view not found"}}`, http.StatusInternalServerError)
		return
	}
	modifiedJSON, err := jsonpatch.MergePatch(jsonProj, jsonBody)
	modifiedProj := &data.Project{}
	err = json.Unmarshal(modifiedJSON, modifiedProj)
	data.UpdateProject(*modifiedProj)
	err = data.ToJSON(modifiedProj, rw)
}

// AddMember handles PATCH requests and add a member to the project
func (p *Projects) AddMember(rw http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)
	id, ok := vars["projectID"]
	jsonBody, err := ioutil.ReadAll(r.Body)
	user := &data.User{}
	err = data.FromJSON(user, r.Body)

	if !ok {
		io.WriteString(rw, `{{"error": "id not found"}}`)
		return
	}

	project, err := data.FindProjectByID(id)

	if err != nil {
		http.Error(rw, `{{"error": "architecture view not found"}}`, http.StatusNotFound)
		return
	}
	jsonProj, err := json.Marshal(project)
	if err != nil {
		http.Error(rw, `{{"error": "architecture view not found"}}`, http.StatusInternalServerError)
		return
	}
	modifiedJSON, err := jsonpatch.MergePatch(jsonProj, jsonBody)
	modifiedProj := &data.Project{}
	err = json.Unmarshal(modifiedJSON, modifiedProj)
	data.UpdateProject(*modifiedProj)
	err = data.ToJSON(modifiedProj, rw)
}
