.PHONY: up down logs ps rebuild reset psql seed migrate-new test lint fmt

up:
	docker compose up -d --build

down:
	docker compose down

logs:
	docker compose logs -f

ps:
	docker compose ps

# package.json や go.mod を変えたあとに実行
rebuild:
	docker compose up -d --build --renew-anon-volumes

# DBも含めて全部作り直す（データは消えます）
reset:
	docker compose down -v
	$(MAKE) up

psql:
	docker compose exec db sh -c 'psql -U $$POSTGRES_USER -d $$POSTGRES_DB'

seed:
	docker compose exec -T db sh -c 'psql -U $$POSTGRES_USER -d $$POSTGRES_DB' < backend/seed/dev.sql

# 使い方: make migrate-new name=add_users
migrate-new:
	docker run --rm -u $(shell id -u):$(shell id -g) -v $(CURDIR)/backend/migrations:/migrations \
		migrate/migrate:v4.18.1 create -ext sql -dir /migrations -seq $(name)

# 以下はコンテナ内で実行する（先に make up が必要。ホストに Go/Node は不要）
test:
	docker compose exec -T backend go test ./...
	docker compose exec -T frontend npm test

lint:
	docker compose exec -T backend go vet ./...
	docker run --rm -v $(CURDIR)/backend:/app -w /app golangci/golangci-lint:v1.64.8 golangci-lint run
	docker compose exec -T frontend sh -c 'npm run lint && npm run typecheck'

# 書き換えたファイルが root 所有にならないよう、ホストのユーザーで実行する
fmt:
	docker compose exec -T -u $(shell id -u):$(shell id -g) backend gofmt -w .
	docker compose exec -T -u $(shell id -u):$(shell id -g) frontend npm run format

