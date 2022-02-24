/**
 * Copyright 2021 Napptive
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package main

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/rs/zerolog/log"
)

const (
	// DefaultPort where the HTTP server will be launched.
	DefaultPort = 8080
	// DefaultMessage to be returned on HTTP calls.
	DefaultMessage = "Hello from version %s commit %s - modified"
)

// Version of the command
var Version string

// Commit from which the command was built
var Commit string

func main() {
	log.Info().Str("version", Version).Str("commit", Commit).Msg("application information")
	server := SimpleHTTPServer{}
	if err := server.Launch(); err != nil {
		log.Error().Err(err).Msg("server failed")
	}
}

type SimpleHTTPServer struct {
}

// Launch the HTTP server.
func (s *SimpleHTTPServer) Launch() error {
	router := mux.NewRouter()
	router.HandleFunc("/", s.HelloHandler)
	listenAddress := fmt.Sprintf(":%d", DefaultPort)
	srv := &http.Server{
		Handler: router,
		Addr:    listenAddress,
	}
	log.Info().Msg("Launching HTTP Server")
	return srv.ListenAndServe()
}

// HelloHandler will return 200 OK plus a message.
func (s *SimpleHTTPServer) HelloHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprint(w, fmt.Sprintf(DefaultMessage, Version, Commit))
}
