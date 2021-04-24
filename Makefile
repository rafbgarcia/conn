start:
	docker compose up -d

stop:
	docker compose stop

rebuild:
	docker compose down && make start
