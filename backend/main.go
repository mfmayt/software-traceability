package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"time"

	auth "traceability/auth"
	"traceability/data"
	"traceability/database"
	archViewHandlers "traceability/handlers/archview"

	componentHandlers "traceability/handlers/archviewcomponents"
	linkHandlers "traceability/handlers/link"
	projectHandlers "traceability/handlers/project"
	userHandlers "traceability/handlers/user"

	"github.com/gorilla/mux"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

const address = ":8080"
const (
	dbHost = "localhost"
	dbPort = 27017
	dbName = "traceability"
)

func main() {

	connectDB()

	sm := mux.NewRouter()
	l := log.New(os.Stdout, "traceability-api", log.LstdFlags)
	v := data.NewValidation()
	uh := userHandlers.NewUsers(l, v)
	ph := projectHandlers.NewProjects(l, v)
	ah := archViewHandlers.NewArchViews(l, v)
	ch := componentHandlers.NewArchViewComponents(l, v)
	lh := linkHandlers.NewLinks(l, v)
	sm.StrictSlash(true)
	setUserEndpoints(sm, uh)
	setProjectEndpoints(sm, ph)
	setArchViewEndpoints(sm, ah)
	setArchViewComponentEndpoints(sm, ch)
	setLinksEndpoints(sm, lh)

	s := http.Server{
		Addr:         address,           // configure the bind address
		Handler:      sm,                // set the default handler
		ErrorLog:     l,                 // set the logger for the server
		ReadTimeout:  5 * time.Second,   // max time to read request from the client
		WriteTimeout: 10 * time.Second,  // max time to write response to the client
		IdleTimeout:  120 * time.Second, // max time for connections using TCP Keep-Alive
	}

	go func() {
		fmt.Println("server is starting at", address)
		err := s.ListenAndServe()

		if err != nil {
			l.Printf("Error starting server: %s\n", err)
			os.Exit(1)
		}
	}()

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	signal.Notify(c, os.Kill)

	// Block until a signal is received.
	sig := <-c
	log.Println("Got signal:", sig)

	// gracefully shutdown the server, waiting max 30 seconds for current operations to complete
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	if cancel != nil {
		fmt.Println("cancel != nil")
	}
	s.Shutdown(ctx)
}

func connectDB() {
	dbURI := fmt.Sprintf("mongodb://%s:%d", dbHost, dbPort)
	clientOptions := options.Client().ApplyURI(dbURI)

	// Connect to MongoDB
	client, err := mongo.Connect(context.TODO(), clientOptions)

	if err != nil {
		log.Fatal(err)
	}

	// Check the connection
	err = client.Ping(context.TODO(), nil)
	if err != nil {
		log.Fatal(err)
	}
	db := client.Database(dbName)
	database.DBCon = client
	database.DB = db

	fmt.Println("Connected to MongoDB!")
}

func setUserEndpoints(sm *mux.Router, uh *userHandlers.Users) {
	getUserList := sm.Methods(http.MethodGet, http.MethodOptions).Subrouter()
	getUserList.HandleFunc("/users/", uh.ListAll)

	getUser := sm.Methods(http.MethodGet, http.MethodOptions).Subrouter()
	getUser.HandleFunc("/users/{id}/", uh.GetUser)
	getUser.Use(auth.CORS)
	getUser.Use(auth.Middleware)

	postUs := sm.Methods(http.MethodPost, http.MethodOptions).Subrouter()
	postUs.HandleFunc("/users", uh.CreateUser)
	postUs.Use(auth.CORS)
	postUs.Use(uh.MiddlewareValidateUser)

	loginUser := sm.Methods(http.MethodPost, http.MethodOptions).Subrouter()
	loginUser.HandleFunc("/login", uh.LoginUser)
	loginUser.Use(auth.CORS)
	loginUser.Use(uh.MiddlewareValidateAuth)
}

func setProjectEndpoints(sm *mux.Router, ph *projectHandlers.Projects) {
	getProj := sm.Methods(http.MethodGet, http.MethodOptions).Subrouter()
	getProj.HandleFunc("/projects/{projectID}/", ph.GetProject)
	getProj.Use(auth.CORS)
	getProj.Use(auth.Middleware)
	getProj.Use(auth.ProjectAuthMiddleware)

	getProjList := sm.Methods(http.MethodGet, http.MethodOptions).Subrouter()
	getProjList.HandleFunc("/users/{userID}/projects/", ph.ListAll)
	getProjList.Use(auth.CORS)
	getProjList.Use(auth.Middleware)

	postProj := sm.Methods(http.MethodPost, http.MethodOptions).Subrouter()
	postProj.HandleFunc("/projects/", ph.CreateProject)
	postProj.Use(auth.CORS)
	postProj.Use(auth.Middleware)
	postProj.Use(ph.MiddlewareValidateProject)

	patchProj := sm.Methods(http.MethodPatch, http.MethodOptions).Subrouter()
	patchProj.HandleFunc("/projects/{projectID}/", ph.UpdateProject)
	patchProj.Use(auth.CORS)
	patchProj.Use(auth.Middleware)
	patchProj.Use(auth.ProjectAuthMiddleware)
}

func setArchViewEndpoints(sm *mux.Router, ah *archViewHandlers.ArchViews) {
	getArchView := sm.Methods(http.MethodGet, http.MethodOptions).Subrouter()
	getArchView.HandleFunc("/projects/{projectID}/views/{id}/", ah.GetArchView)
	getArchView.Use(auth.CORS)
	getArchView.Use(auth.Middleware)
	getArchView.Use(auth.ProjectAuthMiddleware)

	listArchView := sm.Methods(http.MethodGet, http.MethodOptions).Subrouter()
	listArchView.HandleFunc("/projects/{projectID}/views/", ah.ListArchViews)
	listArchView.Use(auth.CORS)
	listArchView.Use(auth.Middleware)
	listArchView.Use(auth.ProjectAuthMiddleware)

	postArchView := sm.Methods(http.MethodPost, http.MethodOptions).Subrouter()
	postArchView.HandleFunc("/projects/{projectID}/views/", ah.CreateArchView)
	postArchView.Use(auth.CORS)
	postArchView.Use(auth.Middleware)
	postArchView.Use(auth.ProjectAuthMiddleware)
	postArchView.Use(ah.MiddlewareValidateArchView)

	patchArchView := sm.Methods(http.MethodPatch, http.MethodOptions).Subrouter()
	patchArchView.HandleFunc("/projects/{projectID}/views/{id}/", ah.UpdateArchView)
	patchArchView.Use(auth.CORS)
	patchArchView.Use(auth.Middleware)
	patchArchView.Use(auth.ProjectAuthMiddleware)
}

func setArchViewComponentEndpoints(sm *mux.Router, ch *componentHandlers.ArchViewComponents) {
	getComp := sm.Methods(http.MethodGet, http.MethodOptions).Subrouter()
	getComp.HandleFunc("/projects/{projectID}/views/{viewID}/components/{id}/", ch.GetArchViewComponent)
	getComp.Use(auth.CORS)
	getComp.Use(auth.Middleware)
	getComp.Use(auth.ProjectAuthMiddleware)

	postComponent := sm.Methods(http.MethodPost, http.MethodOptions).Subrouter()
	postComponent.HandleFunc("/projects/{projectID}/views/{viewID}/components/", ch.AddArchViewComponent)
	postComponent.Use(auth.CORS)
	postComponent.Use(auth.Middleware)
	postComponent.Use(auth.ProjectAuthMiddleware)
	postComponent.Use(ch.MiddlewareValidateArchViewComponent)

	listComponents := sm.Methods(http.MethodGet, http.MethodOptions).Subrouter()
	listComponents.HandleFunc("/projects/{projectID}/views/{viewID}/components/", ch.ListArchViewComponents)
	listComponents.Use(auth.CORS)
	listComponents.Use(auth.Middleware)
	listComponents.Use(auth.ProjectAuthMiddleware)

	listAllComponents := sm.Methods(http.MethodGet, http.MethodOptions).Subrouter()
	listAllComponents.HandleFunc("/projects/{projectID}/components", ch.ListAllComponents)
	listAllComponents.Use(auth.CORS)
	listAllComponents.Use(auth.Middleware)
	listAllComponents.Use(auth.ProjectAuthMiddleware)

	patchComponent := sm.Methods(http.MethodPatch, http.MethodOptions).Subrouter()
	patchComponent.HandleFunc("/projects/{projectID}/views/{viewID}/components/{id}/", ch.UpdateArchViewComponent)
	patchComponent.Use(auth.CORS)
	patchComponent.Use(auth.Middleware)
	patchComponent.Use(auth.ProjectAuthMiddleware)
}

func setLinksEndpoints(sm *mux.Router, lh *linkHandlers.Links) {
	getLinkByID := sm.Methods(http.MethodGet, http.MethodOptions).Subrouter()
	getLinkByID.HandleFunc("/projects/{projectID}/links/{linkID}/", lh.GetLink)
	getLinkByID.Use(auth.CORS)
	getLinkByID.Use(auth.Middleware)
	getLinkByID.Use(auth.ProjectAuthMiddleware)

	getAllLinks := sm.Methods(http.MethodGet, http.MethodOptions).Subrouter()
	getAllLinks.HandleFunc("/links/", lh.ListAll)
	getAllLinks.Use(auth.CORS)
	getAllLinks.Use(auth.Middleware)

	getLinksOfProject := sm.Methods(http.MethodGet, http.MethodOptions).Subrouter()
	getLinksOfProject.HandleFunc("/projects/{projectID}/links/", lh.GetProjectLinks)
	getLinksOfProject.Use(auth.CORS)
	getLinksOfProject.Use(auth.Middleware)
	getLinksOfProject.Use(auth.ProjectAuthMiddleware)

	postLink := sm.Methods(http.MethodPost, http.MethodOptions).Subrouter()
	postLink.HandleFunc("/projects/{projectID}/links/", lh.AddLink)
	postLink.Use(auth.CORS)
	postLink.Use(auth.Middleware)
	postLink.Use(auth.ProjectAuthMiddleware)
	postLink.Use(lh.MiddlewareValidateLink)
}
