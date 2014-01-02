## variables
PWD:=`pwd`
DIST_DIR:=$(PWD)/dist
DIST_HTML_DIR:=$(DIST_DIR)/

SRC_DIR:=$(PWD)/src/view
SRC_TMPL_DIR:=$(SRC_DIR)/tmpl/

## source
all: build

build: html grunt

html: 
	# html components build	
	@echo "> Generate html files from template files..."
	@./bin/gen-html.lisp $(SRC_TMPL_DIR) $(DIST_HTML_DIR)
	@echo "> done."

grunt: html
	# grunt build
	@echo "> Generate js , css , image files..."
	@cd $(SRC_DIR) ; npm install ; grunt
	@echo "> done."

deploy:
	
