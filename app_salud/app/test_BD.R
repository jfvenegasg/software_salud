con <- DBI::dbConnect(RPostgres::Postgres(),
                      host   = "db-postgresql-nyc1-40399-do-user-13749128-0.b.db.ondigitalocean.com",
                      dbname = "defaultdb",
                      user      = "doadmin",
                      password  = "AVNS_bIs97y8paIeqPHstZKp",
                      port     = 25060)

con

df <- data.frame(x = 1, y = "a", z = as.Date("2022-01-01"))

DBI::dbCreateTable(con, name = "my_data", fields = head(df, 0))

#Listar bases de datos en la conexion con
DBI::dbListTables(con)

#Leer tabla "my_data" en conexion con
DBI::dbReadTable(con, "my_data")
