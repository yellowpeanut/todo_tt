# Приложение сырое и не работает
### Для "запуска" требуется:
#### База данных
```
psql -U postgres -c "CREATE USER todo_tt WITH PASSWORD '';"
psql -U postgres -c "CREATE DATABASE todo_tt_development OWNER todo_tt;"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE todo_tt_development TO todo_tt;"

pg_ctl start
```
#### Для приложения
```
bundle
rails db:migrate
rails s
```
