FROM golang:1.25-alpine AS dev
WORKDIR /app
COPY go.mod go.sum* ./
RUN go mod download
RUN go install github.com/air-verse/air@v1.61.7
COPY . .
CMD ["air", "-c", ".air.toml"]
