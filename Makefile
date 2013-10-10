MASTER = tese
POSTER = poster

all: ${MASTER} ${POSTER} doc

${MASTER}:
	latexmk -pdf ${MASTER}

${POSTER}:
	latexmk -pdf ${POSTER}

aspell: ${MASTER_FILE} ${TEX_FILES}
	aspell -l pt-br -c ${MASTER_FILE}
	for f in ${TEX_FILES}; do \
	    aspell -l pt-br -c $$f; \
	done

hunspell:
	hunspell -d pt_BR -c ${MASTER_FILE}
	for f in ${TEX_FILES}; do \
	    hunspell -d pt_BR $$f; \
	done

dev-all: dev-aspell aspell all

dev-aspell: ${DEV_FILES} ${DOC_FILES}
	for f in ${DEV_FILES}; do \
	    aspell -l pt-br -c $$f; \
	done
	for f in ${DOC_FILES}; do \
	    aspell -l pt-br -c $$f; \
	done

dev-hunspell: ${DEV_FILES} ${DOC_FILES}
	for f in ${DEV_FILES}; do \
	    hunspell -d pt_BR $$f; \
	done
	for f in ${DOC_FILES}; do \
	    hunspell -d pt_BR $$f; \
	done

.PHONY: doc clean-all clean clean-doc

doc:
	for i in $$(git branch -r | grep -v HEAD); \
	do \
		git checkout $$i; \
		$(MAKE) tese poster; \
		mv -f tese.pdf doc/samples/$${i/origin\//}.pdf; \
		mv -f poster.pdf doc/samples/poster-$${i/origin\//}.pdf; \
		$(MAKE) clean; \
	done;

clean-all: clean clean-doc

clean:
	latexmk -c

clean-doc:
	rm -f doc/samples/*.pdf
