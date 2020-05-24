package handlers

import (
	"context"
	"net/http"
	"traceability/data"
)

// MiddlewareValidateUser validates the product in the request and calls next if ok
func (p *Users) MiddlewareValidateUser(next http.Handler) http.Handler {
	return http.HandlerFunc(func(rw http.ResponseWriter, r *http.Request) {
		rw.Header().Add("Content-Type", "application/json")

		user := &data.User{}

		err := data.FromJSON(user, r.Body)
		if err != nil {
			p.l.Println("[ERROR] deserializing user", err)

			rw.WriteHeader(http.StatusBadRequest)
			data.ToJSON(&GenericError{Message: err.Error()}, rw)
			return
		}

		// validate the user
		errs := p.v.Validate(user)
		if len(errs) != 0 {

			p.l.Println("[ERROR] validating user", errs)

			// return the validation messages as an array
			rw.WriteHeader(http.StatusUnprocessableEntity)
			data.ToJSON(&ValidationError{Messages: errs.Errors()}, rw)
			return
		}

		// add the user to the context
		ctx := context.WithValue(r.Context(), KeyUser{}, user)
		r = r.WithContext(ctx)

		// Call the next handler, which can be another middleware in the chain, or the final handler.
		next.ServeHTTP(rw, r)
	})
}

// MiddlewareValidateAuth validates the user in the request and calls next if ok
func (p *Users) MiddlewareValidateAuth(next http.Handler) http.Handler {
	return http.HandlerFunc(func(rw http.ResponseWriter, r *http.Request) {
		rw.Header().Add("Content-Type", "application/json")

		auth := &data.Auth{}

		err := data.FromJSON(auth, r.Body)
		if err != nil {
			p.l.Println("[ERROR] deserializing user", err)

			rw.WriteHeader(http.StatusBadRequest)
			data.ToJSON(&GenericError{Message: err.Error()}, rw)
			return
		}

		// validate the user
		errs := p.v.Validate(auth)
		if len(errs) != 0 {

			p.l.Println("[ERROR] validating auth", errs)

			// return the validation messages as an array
			rw.WriteHeader(http.StatusUnprocessableEntity)
			data.ToJSON(&ValidationError{Messages: errs.Errors()}, rw)
			return
		}

		// add the user to the context
		ctx := context.WithValue(r.Context(), KeyAuth{}, auth)
		r = r.WithContext(ctx)

		// Call the next handler, which can be another middleware in the chain, or the final handler.
		next.ServeHTTP(rw, r)
	})
}
