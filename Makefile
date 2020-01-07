VERSION     = 1.0.1
AUTHOR		= arvintian
PROJECT     = code-server

build:
	docker build -t $(PROJECT):$(VERSION) .

publish:
	docker tag $(PROJECT):$(VERSION) $(AUTHOR)/$(PROJECT):$(VERSION)
	docker push $(AUTHOR)/$(PROJECT):$(VERSION)