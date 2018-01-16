FROM 10up/phpfpm

# Set Default WP Snapshot Values
ARG WPSNAPSHOTS_REPO=""
ARG WPSNAPSHOTS_AWS_KEY=""
ARG WPSNAPSHOTS_AWS_SECRET=""
ARG WPSNAPSHOTS_USER=""
ARG WPSNAPSHOTS_EMAIL=""

# Assign Build Arguments to Environmental Variables to pass them to child containers.
ENV WPSNAPSHOTS_REPO="$WPSNAPSHOTS_REPO" WPSNAPSHOTS_AWS_KEY="$WPSNAPSHOTS_AWS_KEY" WPSNAPSHOTS_AWS_SECRET="$WPSNAPSHOTS_AWS_SECRET" WPSNAPSHOTS_USER="$WPSNAPSHOTS_USER" WPSNAPSHOTS_EMAIL="$WPSNAPSHOTS_EMAIL"

# Add WP Snapshot repository to composer.
RUN if [ -n "$WPSNAPSHOTS_REPO" ]; then composer global config repositories.wpsnapshots vcs https://github.com/10up/wpsnapshots; fi;

# Require Snapshots for this project.
RUN if [ -n "$WPSNAPSHOTS_REPO" ]; then composer global require 10up/wpsnapshots:dev-master -n; fi;

# Export composers bin directory.
ENV PATH="/root/.composer/vendor/bin:${PATH}"

# Configure WP Snapshots if values assigned.
RUN if [ -n "$WPSNAPSHOTS_REPO" ]; then wpsnapshots configure ${WPSNAPSHOTS_REPO} --aws_key="${WPSNAPSHOTS_AWS_KEY}" --aws_secret="${WPSNAPSHOTS_AWS_SECRET}" --user_name="${WPSNAPSHOTS_USER}" --user_email="${WPSNAPSHOTS_EMAIL}"; fi;

# Create WP Snapshots, no-op if already created.
RUN if [ -n "$WPSNAPSHOTS_REPO" ]; then wpsnapshots create-repository; fi;

CMD ["php-fpm"]

EXPOSE 9000
