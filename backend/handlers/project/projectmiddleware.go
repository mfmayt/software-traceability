package handlers

import (
	"context"
	"net/http"
	"traceability/data"
)

// MiddlewareValidateProject validates the project in the request and calls next if ok
func (p *Projects) MiddlewareValidateProject(next http.Handler) http.Handler {
	return http.HandlerFunc(func(rw http.ResponseWriter, r *http.Request) {
		rw.Header().Add("Content-Type", "application/json")

		project := &data.Project{}

		err := data.FromJSON(project, r.Body)
		if err != nil {
			p.l.Println("[ERROR] deserializing user", err)

			rw.WriteHeader(http.StatusBadRequest)
			data.ToJSON(&GenericError{Message: err.Error()}, rw)
			return
		}

		// validate the project
		errs := p.v.Validate(project)
		if len(errs) != 0 {

			p.l.Println("[ERROR] validating user", errs)

			// return the validation messages as an array
			rw.WriteHeader(http.StatusUnprocessableEntity)
			data.ToJSON(&ValidationError{Messages: errs.Errors()}, rw)
			return
		}

		// add the project to the context
		ctx := context.WithValue(r.Context(), KeyProject{}, project)
		r = r.WithContext(ctx)

		// Call the next handler, which can be another middleware in the chain, or the final handler.
		next.ServeHTTP(rw, r)
	})
}

// MiddlewareValidatePermission validates the user in the request and calls next if ok
func (p *Projects) MiddlewareValidatePermission(next http.Handler) http.Handler {
	return http.HandlerFunc(func(rw http.ResponseWriter, r *http.Request) {
		rw.Header().Add("Content-Type", "application/json")

		// TODO: will be implemented\
		// user := r.Context().Value("user")
		// token, err := jwtmiddleware.FromAuthHeader(r)
		// user, err := data.FindUserByAccessToken(token)
		// data.FindMemberRoleInProject()
		// for k, v := range user.(*jwt.Token).Claims.(jwt.MapClaims) {
		// 	fmt.Fprintf(w, "%s :\t%#v\n", k, v)
		//   }
		// Call the next handler, which can be another middleware in the chain, or the final handler.
		next.ServeHTTP(rw, r)
	})
}
