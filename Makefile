VERSION=0.56.3

generate: hugo update
	hugo

install:
	@echo Installing Hugo
	@wget https://github.com/gohugoio/hugo/releases/download/v$(VERSION)/hugo_extended_$(VERSION)_Linux-64bit.deb
	@sudo dpkg -i hugo*.deb
	@rm hugo*.deb

update:
	@git submodule update --remote --rebase