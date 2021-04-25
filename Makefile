start:
	docker compose up -d

stop:
	docker compose stop

rebuild:
	docker compose down && make start

create_test_schema:
	MIX_ENV=test mix connect.recreate_schema
