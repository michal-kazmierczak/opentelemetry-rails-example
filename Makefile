dc=docker-compose

up:
	$(dc) up -d

rails_c:
	$(dc) exec web_app bin/rails c

psql:
	$(dc) exec postgres psql -U postgres -d opentelemetry_rails

create_db:
	$(dc) run init_database bin/rake db:setup

seed:
	$(dc) run init_database bin/rake db:seed

drop_db:
	$(dc) run init_database -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bin/rake db:drop
