VERSION     = 1.2.0
AUTHOR		= arvintian
PROJECT     = code-server

build:
	docker build -t $(PROJECT):$(VERSION) .

publish:
	docker tag $(PROJECT):$(VERSION) $(AUTHOR)/$(PROJECT):$(VERSION)
	docker push $(AUTHOR)/$(PROJECT):$(VERSION)