default:
	podman build -t quay.io/terarocket/haikeuken:latest .
push:
	podman push quay.io/terarocket/haikeuken:latest
setup_test:
	podman network create haikeuken-net || true
	podman run -P -d --network haikeuken-net --name postgres -e POSTGRES_USER=postgresadmin -e POSTGRES_PASSWORD=admin123 postgres:10.4
app_test:
	podman run -P --network haikeuken-net -e DATABASE_URL="postgres://postgresadmin:admin123@postgres:5432/haikeuken" -e SECRET_KEY_BASE=testsecure quay.io/terarocket/haikeuken:latest app
