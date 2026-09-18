# /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/Makefile
.PHONY: lint test
lint:
	shellcheck ,fix_dir_names.sh

test: lint
	shellspec spec/clean_name_spec.sh spec/,fix_dir_names_spec.sh
	