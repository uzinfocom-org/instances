# Matrix Server {#uzinfocom-matrix}

## Bootstrapping server

Switch into postgres user and open psql shell, then execute:

```sql
CREATE ROLE "matrix-synapse";
CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
  TEMPLATE template0
  LC_COLLATE = "C"
  LC_CTYPE = "C";

CREATE DATABASE "matrix" WITH OWNER "matrix-synapse"
  TEMPLATE template0
  LC_COLLATE = "C"
  LC_CTYPE = "C";

ALTER ROLE "matrix-synapse" LOGIN;
```
