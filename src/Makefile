.PHONY: __usage__ all clean help
export

# fetch informations about the latest release
latest_release_github = wget -qO- "https://api.github.com/repos/${1}/releases/latest"
# ensure the release is production grade
latest_release_jq := jq -re '.|select(.draft==false)|select(.prerelease==false).tag_name|ltrimstr("v")'

CTOP_VERSION := latest
DOCKER_VERSION := latest
DOCKER_URL = "https://download.docker.com/linux/static/stable/x86_64"
GITLAB_RUNNER_VERSION := latest

__usage__:
	@$(error try: $(MAKE) help)


all: ctop docker.tgz gitlab-runner-linux-amd64


ctop:
	@CTOP_VERSION=${CTOP_VERSION};\
	[ -z "${CTOP_VERSION%latest}" ] &&\
	CTOP_VERSION=$(shell $(call latest_release_github,bcicen/ctop) | $(latest_release_jq));\
	$(MAKE) --no-print-directory ctop-$${CTOP_VERSION} &&\
	ln -fv ctop-$${CTOP_VERSION} $@
	@chmod 0755 $@
	@strip -s $@

ctop-%:
	@wget -O $@ "https://github.com/bcicen/ctop/releases/download/v${*}/ctop-${*}-linux-amd64"


docker.tgz:
	@DOCKER_VERSION=${DOCKER_VERSION};\
	[ -z "${DOCKER_VERSION%latest}" ] &&\
	DOCKER_VERSION=$(shell $(call latest_release_github,moby/moby) | $(latest_release_jq));\
	$(MAKE) --no-print-directory docker-$${DOCKER_VERSION}.tgz &&\
	ln -fv docker-$${DOCKER_VERSION}.tgz $@

docker-%.tgz:
	@wget -O $@ "${DOCKER_URL}/docker-$(*).tgz"


gitlab-runner-linux-amd64:
	@GITLAB_RUNNER_VERSION=${GITLAB_RUNNER_VERSION};\
	[ -z "${GITLAB_RUNNER_VERSION%latest}" ] &&\
	GITLAB_RUNNER_VERSION=$$(\
		wget -qO- https://gitlab.com/api/v4/projects/gitlab-org%2fgitlab-runner/releases/permalink/latest |\
		jq -r '.tag_name'\
	);\
	wget -O $@ "https://gitlab.com/api/v4/projects/gitlab-org%2fgitlab-runner/releases/v$${GITLAB_RUNNER_VERSION#v}/downloads/binaries/gitlab-runner-linux-amd64"
	@chmod 0755 $@
	@strip -s $@


clean:
	@rm -vf ctop* docker*.tgz gitlab-runner-linux-amd64

# Must be last
help:
	$(info List of available targets:)
	@$(MAKE) -npr | \
		awk -F: '\
		/^[a-zA-Z0-9][^$$#\/\t%=]*:([^=]|$$)/{ \
		split($$1,A,/ /);for(i in A)print A[i] \
	}' | sed '/^[Mm]ake/d;s/^/\t/' \
	| sort -n
