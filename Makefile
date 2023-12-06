dc=docker-compose

up:
	$(dc) up -d

rails_c:
	$(dc) exec rails_app bin/rails c
