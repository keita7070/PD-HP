# 研究室紹介サイト

バックエンド: Go / フロントエンド: TypeScript (React + Vite) / DB: PostgreSQL
すべて Docker で動かします。Go や Node.js を自分の PC に入れる必要はありません。

## 1. 事前に入れるもの

| ツール | 補足 |
|---|---|
| Git | |
| Docker Desktop | Windows は「WSL 統合」をオンにする |
| make | Mac / Linux は標準で入っている |

### Windows の人へ（重要）

- WSL2（Ubuntu）を使い、以降の操作はすべて **WSL のターミナル** で行ってください。
- プロジェクトは WSL の中（`~/lab-site` など）に置いてください。`/mnt/c/...` には置かないでください。
- VS Code は、拡張機能「WSL」を入れたうえで、WSL のターミナルから `code .` で開いてください。
  `\\wsl.localhost\...` から直接開くと、改行コード（CRLF）が混ざります。

## 2. 初回セットアップ

```
git clone <リポジトリのURL>
cd lab-site
cp .env.example .env
openssl rand -hex 32
```

出力された文字列を、`.env` の `SESSION_SECRET=` の後ろに貼ります。
`.env` のほかの値は、そのままで動きます。`.env` は Git に入れないでください。

```
make up
make seed
```

`make up` の最初のビルドは数分かかります。

## 3. 動作確認

- http://localhost:5173 を開いて「API の状態: ok」と表示されれば成功です。
- `make ps` で `db`・`backend`・`frontend` が Up になっています。
- `make psql` → `SELECT id, name FROM labs;` でサンプル2件が出ます（終了は `\q`）。

## 4. 日常のコマンド

| やりたいこと | コマンド |
|---|---|
| 起動 / 停止 | `make up` / `make down` |
| ログを見る | `make logs` |
| DBに入る | `make psql` |
| サンプルデータを入れる | `make seed` |
| DBを初期化（データは消えます） | `make reset` |
| テーブルを変える | `make migrate-new name=変更内容` → 作られたSQLを書く → `make up` |
| テスト | `make test` |
| lint | `make lint` |
| 整形 | `make fmt` |

`make test` / `make lint` / `make fmt` は、`make up` で起動している状態で実行します。

## 5. 最新のコードを取り込むとき

```
git pull
make rebuild
```

`package.json` や `go.mod` が変わっていたときは、`make rebuild` が必要です。

## 6. 困ったとき

| 症状 | 対処 |
|---|---|
| 起動時に変数が空だと言われる | `.env` を作っていない。`cp .env.example .env` |
| backend がすぐ止まる | `make logs` を見る。`SESSION_SECRET` が空、または32文字未満のことが多い |
| ポートが使用中と言われる | 5432・8080・5173 を使っている他のアプリを止める |
| コードを変えても画面が変わらない（Mac/Windows） | `docker-compose.yml` の `VITE_USE_POLLING` の行のコメントを外す |
| `make` で `missing separator` | `Makefile` のインデントがスペースになっている。タブ文字にする |
| `make` が使えない | `docker compose up -d --build` を直接実行する |

## 7. フォルダ構成

```
lab-site/
├── docker-compose.yml
├── Makefile
├── .env.example
├── backend/      # Go（API・DB接続）
│   ├── cmd/server/main.go
│   ├── internal/{config,db,server}/
│   ├── migrations/   # DBの構造（SQL）
│   └── seed/dev.sql  # 開発用サンプルデータ
└── frontend/     # TypeScript（画面）
    └── src/
```
