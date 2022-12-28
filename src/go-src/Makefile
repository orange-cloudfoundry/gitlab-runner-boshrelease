.PHONY: all clean

all: docker-registry-certs

docker-registry-certs:
	@go mod tidy
	@go mod vendor
	@go build

clean:
	@rm -vf docker-registry-certs
