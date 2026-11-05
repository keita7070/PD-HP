package server

import (
	"context"
	"encoding/json"
	"net/http"
	"time"
)

// Pinger は DB の疎通確認だけを抽象化したもの（テストで差し替えられる）。
type Pinger interface {
	Ping(ctx context.Context) error
}

type Server struct {
	db Pinger
}

func New(db Pinger) *Server {
	return &Server{db: db}
}

func (s *Server) Routes() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /api/health", s.health)
	// ここに研究室API・管理者APIのルートを足していく
	return mux
}

func (s *Server) health(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 2*time.Second)
	defer cancel()

	status, code := "ok", http.StatusOK
	if err := s.db.Ping(ctx); err != nil {
		status, code = "db unavailable", http.StatusServiceUnavailable
	}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	_ = json.NewEncoder(w).Encode(map[string]string{"status": status})
}
