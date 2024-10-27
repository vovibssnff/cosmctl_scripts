FROM bellsoft/liberica-openjdk-debian:17 

RUN set -x \
        && addgroup --system --gid 102 crossroads-admin \
        && adduser --system --disabled-login --ingroup crossroads-admin --no-create-home --home /nonexistent --gecos "Crossroads admin user" --shell /bin/false --uid 102 crossroads-admin \
	&& apt update \
        && apt install -y --no-install-recommends \
                gettext-base jq \
        && rm -rf /tmp/* 



RUN mkdir -p /opt/crossroads \
        && chown -R crossroads-admin:crossroads-admin /opt/crossroads \
        && mkdir -p /var/secret \
        && chown -R crossroads-admin:crossroads-admin /var/secret \
        && mkdir -p /opt/cloud \
        && chown -R crossroads-admin:crossroads-admin /opt/cloud

COPY --chown=crossroads-admin:crossroads-admin ./target/crossroads-back-end-0.0.1-SNAPSHOT.jar /opt/crossroads/
COPY --chown=crossroads-admin:crossroads-admin ./startApp.sh /opt/crossroads/

COPY --chown=crossroads-admin:crossroads-admin token.file /var/secret/hc_vault_token
COPY --chown=crossroads-admin:crossroads-admin host.file /var/secret/hc_vault_host
COPY --chown=crossroads-admin:crossroads-admin ./Docker/configResolver.sh ./Docker/resolveConfiguration.sh ./Docker/environment.template /opt/cloud/


CMD /opt/crossroads/startApp.sh
